---
title: Usage
permalink: usage/
layout: about
---

# Usage

This page describes an example analysis of an individual disease. First, go to the [traits]({{ site.baseurl }}traits/) tab and search for Schizophrenia, or follow this link to the [schizophrenia trait view]({{ site.baseurl }}traits/Schizophrenia).

### Trait view

The first table of the Trait View shows all of the transcriptome-wide significant associations for the given trait (after bonferroni correction for all [models]({{ site.baseurl }}models/) tested). Loci have been grouped into contiguous blocks and model selection run on each locus to identify the independently significant genes (which are reported in the right-most column).

The second table of the Trait View shows all pleiotropic associations to other traits for any of the independently significant genes. You can filter this table by disease or gene. The table is ordered by the "Chi<sup>2</sup> ratio" which is computed as the average Chi<sup>2</sup> statistic for the selected genes in the secondary trait, divided by the average statistic for all genes in the secondary trait. Ignoring issues of LD, this is an estimate of the heritability enrichment of the target genes relative to all genes and tends to provide reasonable results. For example, we can see that schizophrenia associated genes are also enriched for bipolar disorder, smoking, blood pressure, anxiety, nervous feelings, etc. The remaining columns list the number of significant genes in the target trait at Bonferroni correction [+] and at transcriptome-wide significance [++], the correlation of effect-sizes across the [+] genes, as well as links to each of the [+] genes.

*NB: (1) although we represent the associations as genes, we are actually testing for the same associated tissue/model; (2) we use the jointly significant genes so that the pleiotropy statistics are computed from independent data points, but other correlated genes from each locus should also be treated as pleiotropic*.

The third table of the Trait View shows the breakdown of associations by gene expression panel. These are ordered by the average TWAS Chi<sup>2</sup> statistic in the panel -- an estimate of the average trait heritability explained by predictors from that expression study. The columns also report the # and % of significant associations from that study. In this case, we see no relevant tissue-specific enrichment for schizophrenia (see [Prostate Cancer]({{ site.baseurl }}traits/Prostate_Cancer/) for an example of tissue specificity).

### Locus view

Click on [locus #7]({{ site.baseurl }}traits/Schizophrenia/7/) in the schizophrenia associations table to go to the Locus View for the *CNTN4* locus. The top panel shows a Manhattan plot of the GWAS association before and after conditioning on the predicted expression (see [About]({{ site.baseurl }}about) for more details on conditioning). The next panel shows all of the significantly associated models, their model performance, correlation with the top index SNP, and *coloc* posterior probabilities (PP3 = two distinct causal variants; PP4 = a single shared causal variant). Here we see a single predictive model for *CNTN4* at this locus (from CommonMind brain) with a high PP4 and a much stronger TWAS vs eQTL Z-score, suggesting the TWAS is aggregating additional predictive signal - all good indicators of a pleiotropic effect. Since only one model is significant in the locus it is the "joint"ly selected model by default.

### Gene view

Click on [CNTN4]({{ site.baseurl }}genes/CNTN4/) to go to the Gene View. The top table shows all of the predictive models that have been computed for this gene and their respective performance. Here we again see that for the model trained in brain, the best multivariate predictive model (in this case elastic net with cross-validation P=4.7e-07) far outperforms the best eQTL (P=2.3e-04), which provides further confidence that the TWAS predictor is capturing real additional signal and leading to a more significant disease association.

The second table of the gene view shows a heatmap of association for this gene between all traits (rows) and all models (columns 4-). We order the heatmap by the "avg Chi<sup>2</sup> ratio" column, which is computed as the average Chi<sup>2</sup> for the gene-disease pair (across all models) divided by the average Chi<sup>2</sup> for all genes in the listed disease (across all models). This normalization accounts for sample size and heritability differences between traits and emphasize associations that are stronger than expected by chance (without the normalization, highly heritable and polygenic traits like height, for example, would constantly be at the top of the list simply because they have so many detectable causal variants). The subsequent columns list the raw average Chi<sup>2</sup> statistic, maximum Chi<sup>2</sup> statistic across all models (to filter for model-specific associations), and then the individual Z-scores for each model. Here we see that schizophrenia is the second most enriched trait for *CNTN4* associations, followed by feelings-related measurements -- potentially informing our understanding of how this gene fits into the cross-trait relationships. Sorting on column #1 shows that the brain model is only significantly associated with schizophrenia. Sorting on the "max chi2" column shows that no other models are strongly associated (with any trait), i.e. this is a brain-specific effect.

*CNTN4* was recently implicated in schizophrenia and shown to change neurodevelopment in zebrafish by [Fromer et al. 2016 Nat Neurosci](https://www.ncbi.nlm.nih.gov/pubmed/27668389).
