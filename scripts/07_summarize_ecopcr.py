"""07_summarize_ecopcr.py - summarize the ecoPCR runs of step 06, with checks.

Usage (from the repository root): python3 scripts/07_summarize_ecopcr.py
Reads results/insilico_selected_pairs.tsv, results/ecopcr/raw/, the FASTA
files in data/processed/ (to count the target sequences), config/targets.tsv
and the ecoPrimers outputs in results/<target>/.
Writes, in results/ecopcr/:
  ecopcr_pairs.tsv    one line per pair
  ecopcr_hits.tsv     one line per amplified taxon per pair (best hit of each taxon)
  ecopcr_designs.tsv  one line per design and primer length
Every hit is checked: the mismatches recounted from the primer site must
equal the count ecoPCR reports, <= 3 per primer, amplicon 50-300 bp, and
the header must show the expected database, primers and parameters.
It also checks that the sequences amplified with no mismatch (amplicon
150-300 bp) are, for target and non-target, as many as ecoPrimers reported
for the pair (columns 11 and 12 of its output, strict matching)."""
import csv, re, sys, os, collections

os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
pairs_f, raw_dir, data_dir, targets_f, out = ('results/insilico_selected_pairs.tsv', 'results/ecopcr/raw',
                                              'data/processed', 'config/targets.tsv', 'results/ecopcr')
MAXE, LMIN, LMAX, THREE = 3, 50, 300, 5

targets = {r['target_id']: r for r in csv.DictReader(open(targets_f), delimiter='\t')}
n_target_seqs = {}
for t, r in targets.items():
    n_target_seqs[t] = sum(1 for l in open(f"{data_dir}/{t}/{t}.fasta")
                           if l.startswith('>') and f"taxid={r['root_taxid']};" in l)

def mism(primer, site):
    site = site.strip().upper()
    assert len(site) == len(primer), (primer, site)
    return [len(primer) - i for i, (a, b) in enumerate(zip(primer, site)) if a != b]

problems = []
ecop = {}
pair_rows, hit_rows = [], []
pairs = list(csv.DictReader(open(pairs_f), delimiter='\t'))
for p in pairs:
    t, N, serial = p['target_id'], p['primer_length'], p['serial']
    root = targets[t]['root_taxid']
    excluded = set(x for x in targets[t]['excluded_taxids'].split(',') if x)
    pid = f"{t}_{N}_{serial}"
    path = f"{raw_dir}/{pid}.ecopcr"
    if not os.path.exists(path):
        problems.append(f"{pid}: output missing"); continue
    lines = open(path).read().splitlines()
    hdr = '\n'.join(l for l in lines if l.startswith('#'))
    db = re.search(r'database : (\S+)', hdr).group(1)
    checks = [db.split('/')[-1] in (f'banco_{t}', f'{t}_db'),
              'max error count by oligonucleotide : 3' in hdr,
              'amplifiat length between [50,300]' in hdr,
              'output in kingdom mode' in hdr,
              re.search(r'oligo1 : (\S+)', hdr).group(1) == p['forward'],
              re.search(r'oligo2 : (\S+)', hdr).group(1) == p['reverse']]
    if not all(checks):
        problems.append(f"{pid}: header check failed {checks}")
    best = {}
    n_target_hits = 0; target_mm = []
    strict_t = strict_c = 0
    for l in lines:
        if l.startswith('#') or not l.strip():
            continue
        c = [x.strip() for x in l.split('|')]
        acc, taxid, sp_taxid, sp_name = c[0], c[2], c[4], c[5]
        e1, e2, amp = int(c[14]), int(c[17]), int(c[19])
        m1, m2 = mism(p['forward'], c[13]), mism(p['reverse'], c[16])
        if len(m1) != e1 or len(m2) != e2:
            problems.append(f"{pid} {acc}: recount {len(m1)}/{len(m2)} vs ecoPCR {e1}/{e2}")
        if e1 > MAXE or e2 > MAXE or not (LMIN <= amp <= LMAX):
            problems.append(f"{pid} {acc}: out of range e={e1}/{e2} amp={amp}")
        key_taxid = sp_taxid if sp_taxid not in ('', '-1', '0') else taxid
        name = sp_name if sp_name and not sp_name.startswith('#') else c[21].split(' voucher')[0]
        is_target = key_taxid == root
        if e1 == 0 and e2 == 0 and 150 <= amp <= 300:
            if is_target: strict_t += 1
            else: strict_c += 1
        if is_target:
            n_target_hits += 1; target_mm.append(e1 + e2)
        three = sum(1 for d in m1 + m2 if d <= THREE)
        hit = dict(pair_id=pid, target_id=t, primer_length=N, serial=serial,
                   taxid=key_taxid, species=name, family=c[9],
                   role='target' if is_target else ('excluded taxon (hybrid or missing taxid)' if key_taxid in excluded else 'non-target'),
                   accession=acc, mm_forward=e1, mm_reverse=e2, mm_total=e1 + e2,
                   mm_within_5_of_3prime=three,
                   mm_pos_from_3prime_forward=','.join(map(str, m1)),
                   mm_pos_from_3prime_reverse=','.join(map(str, m2)),
                   amplicon_length=amp)
        k = (hit['mm_total'], hit['mm_within_5_of_3prime'])   # most likely to amplify first
        if key_taxid not in best or k < (best[key_taxid]['mm_total'], best[key_taxid]['mm_within_5_of_3prime']):
            best[key_taxid] = hit
    eco = ecop.setdefault((t, N), {})
    if not eco:
        for l in open(f"results/{t}/{t}_ecoprimers{N}.csv"):
            if not l.startswith('#') and l.strip():
                f = [x.strip() for x in l.split('	')]
                eco[f[0]] = (int(f[10]), int(f[11]))
    if eco.get(serial) != (strict_t, strict_c):
        problems.append(f"{pid}: strict amplification {strict_t}/{strict_c} vs ecoPrimers {eco.get(serial)}")
    hits = sorted(best.values(), key=lambda h: (h['role'] != 'target', h['mm_total'], h['mm_within_5_of_3prime'], h['species']))
    hit_rows += hits
    non = [h for h in hits if h['role'] == 'non-target']
    excl_hits = [h for h in hits if h['role'].startswith('excluded')]
    margin = min((h['mm_total'] for h in non), default=None)
    closest = [h for h in non if h['mm_total'] == margin]
    tgt = best.get(root)
    pair_rows.append(dict(
        pair_id=pid, target_id=t, primer_length=N, serial=serial,
        forward=p['forward'], reverse=p['reverse'],
        target_amplified='yes' if tgt else 'no',
        target_seqs_amplified=f"{n_target_hits}/{n_target_seqs[t]}",
        target_mm_total=max(target_mm) if target_mm else '',
        target_amplicon=tgt['amplicon_length'] if tgt else '',
        nontarget_species_amplified=len(non),
        **{f'nontarget_mm{k}': sum(1 for h in non if h['mm_total'] == k) for k in range(0, 7)},
        margin_mm=margin if margin is not None else 'none',
        closest_species='; '.join(h['species'] for h in closest),
        closest_mm_forward_reverse='; '.join(f"{h['mm_forward']}+{h['mm_reverse']}" for h in closest),
        closest_mm_within_5_of_3prime='; '.join(str(h['mm_within_5_of_3prime']) for h in closest),
        excluded_taxa_amplified=len(excl_hits)))

def write(path, rows):
    keys = list(dict.fromkeys(k for r in rows for k in r))
    with open(path, 'w', newline='') as f:
        w = csv.DictWriter(f, keys, delimiter='\t', restval='', lineterminator='\n')
        w.writeheader(); w.writerows(rows)

os.makedirs(out, exist_ok=True)
write(f"{out}/ecopcr_pairs.tsv", pair_rows)
write(f"{out}/ecopcr_hits.tsv", hit_rows)
des = collections.OrderedDict()
for r in pair_rows:
    d = des.setdefault((r['target_id'], r['primer_length']), collections.Counter())
    d['pairs'] += 1
    d['target_amplified'] += r['target_amplified'] == 'yes'
    d['no_nontarget_species'] += r['margin_mm'] == 'none'
    if r['margin_mm'] != 'none':
        d[f"margin_{min(int(r['margin_mm']), 4)}"] += 1
write(f"{out}/ecopcr_designs.tsv", [dict(target_id=k[0], primer_length=k[1], pairs=v['pairs'],
      target_amplified=v['target_amplified'], no_nontarget_species=v['no_nontarget_species'],
      margin_4_or_more=v['margin_4'], margin_3=v['margin_3'], margin_2=v['margin_2'],
      margin_1=v['margin_1'], margin_0=v['margin_0']) for k, v in des.items()])
print(f"[07] pairs: {len(pair_rows)}  taxon hits: {len(hit_rows)}  problems: {len(problems)}")
for x in problems[:30]:
    print('PROBLEM', x)
sys.exit(1 if problems else 0)
