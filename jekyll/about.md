---
title: About
permalink: about/
layout: about
---

# About

TWAS measures the genetic association between gene expression and a complex phenotype using only GWAS summary-level data (see: [Gusev et al. 2016 Nat Genet](https://www.ncbi.nlm.nih.gov/pubmed/26854917)). The TWAS central dogma is that associated genes are more likely to be causal mediators of the disease and thus informative of disease biology or as targets for experimental follow-up. 

TWAS hub is an interactive browser of results from integrative analyses of GWAS and functional data for hundreds of traits and >100k expression models. The aim is facilitate the investigation of individual TWAS associations; pleiotropic disease/trait associations for a given gene of interest; predicted gene associations for a given disease/trait of interest with detailed per-locus statistics; and pleiotropic relationships between traits based on shared associated genes. See the [USAGE]({{ site.baseurl }}/usage){: .border} tab for detailed examples of each analysis type. TWAS hub was developed in the [Gusev Lab](http://gusevlab.org) at the Dana-Farber Cancer Institute and Harvard Medical School. For questions or comments please contact [alexander_gusev@dfci.harvard.edu](mailto:alexander_gusev@dfci.harvard.edu). Please cite [Mancuso et al. 2017 AJHG](https://www.ncbi.nlm.nih.gov/pubmed/28238358){: .border} if you find this resource useful.

# FAQ

## How is TWAS hub generated?

For each trait, a TWAS is carried out using the [FUSION](http://gusevlab.org/projects/fusion/) software. FUSON post-processing is then used to extract all significant associations (after Bonferroni correction) and grouped into contiguous loci and a step-wise conditional analysis is performed to identify independent associations (see more below). TWAS-reporter is then run on all traits to generate Markdown formatted reports which are human readable or can be flexibly converted to html/pdf/etc. We use a custom Jekyll layout to present these reports as a static web-site with data elements made interactive through javascript. Tables are handled by datatables.js and plots are handled by plotly.js. All code is available [on GitHub](https://github.com/gusevlab/TWAS_HUB). All data for each trait is available from the <i class="far fa-file-archive" aria-hidden="true"></i> links in the [TRAITS]({{ site.baseurl }}/traits){: .border} tab.

## What does a TWAS association really mean?

Please read this [blog post](http://sashagusev.github.io/2017-10/twas-vulnerabilities.html) for much more about interpreting TWAS signals and the relationship between TWAS, other methods, and complex disease architectures. 

## Predictive models and weights.

The predictive models and weight used for all analyses are listed in the [MODELS]({{ site.baseurl }}/models/){: .border} page and available for download through the [FUSION](http://gusevlab.org/projects/fusion/) web-site. Genotypes are restricted to common, well-imputed HapMap3 SNPs that satisfied standard quality-control thresholds on missingness and hardy-weinberg equilibrium. Typically, gene expression was analyzed with covariates for sex, age, genetic ancestry, and multiple gene expression PCs (specific panel details are presented on the main FUSION web-site). *Note: for analyses of gene expression in tumors local copy number alterations were not modelled, we are evaluating  the best way to adjust for somatic events so these weights may be updated*.

## Interpretation of low significance models.

All analyses include weakly predictive models up to a heritability P-value of 0.01. This means you will sometimes see models with negative cross-validation (adjusted) R<sup>2</sup> values because the heritable signal is not predictive after reducing 4/5 folds. These models are included primarily for individual gene look-up where the multiple-testing burden is negligible and weakly significant models may still be informative (alternatively, if you don't see a model for a gene it's because there wasn't a hint of signal un the data). For genomewide scans we recommend interpreting these models with caution.

## Interpretation of the conditional analysis.

The conditional analysis is a simple summary based step-wise model selection process that iteratively adds predictors to the model in decreasing order of conditional TWAS significance until no significant associations remain. Across models, conditional results should be interpreted as estimating the number of jointly significant models, but the selected models are not necessarily more likely to be causal than unselected features (either due to high correlation or different levels of noise). Rather, we recommend using a formal fine-mapping procedure (e.g. [FOCUS](https://github.com/bogdanlab/focus)). Additionally, the SNP conditioning analysis (and Manhattan plots) provide an estimate of variance in the locus explained by the predicted model. A small fraction of variance explained is a strong indicator that the predicted model is tagging another causal feature (or there are multiple causal features in the locus). A large fraction of variance explained is consistent with the predicted model explaining all of the genetic effect - necessary but not sufficient for this to be the single causal mediator.

The conditional analysis uses an LD-reference panel and is therefore approximate, so you may see loci that behave unusually (for example, becoming extremely significant after conditioning). These are most likely instances of LD mismatch between reference and GWAS data. In instances where the full conditional analysis is unstable, the "top SNP corr" column still provides a useful estimate of the marginal correlation between the gene model and the top GWAS SNP, the square of which is the estimate of variance explained by that model alone.

## Interpretation of coloc posteriors

All transcriptome-wide significant associations are run through the *coloc* colocalization model, with posterior probabilities PP3 (distinct causal variant) and PP4 (shared causal variant) reported in the locus view. *coloc* assumes a single causal variant model while TWAS directly models multiple eQTLs so we tend to use low PP3 as an indicator of colocalization rather than high PP4 (as done in [Raj et al. 2017 biorxiv](https://www.biorxiv.org/content/early/2017/08/10/174565)).

## Acknowledgments

Hundreds of UK BioBank phenotypes were processed, analyzed, and made openly available by the [Neale lab rapid GWAS release](http://www.nealelab.is/blog/2017/7/19/rapid-gwas-of-thousands-of-phenotypes-for-337000-samples-in-the-uk-biobank), which motivated the development of this interface. The remaining GWAS summary data used here was harmonized by Hilary Finucane ([Finucane et al. Nat Genet 2015](https://www.ncbi.nlm.nih.gov/pubmed/26414678)), Steven Gazal ([Gazal et al. 2017 Nat Genet](https://www.ncbi.nlm.nih.gov/pubmed/28892061)), and Po-Ru Loh ([Loh et al. 2018 biorxiv](https://www.biorxiv.org/content/early/2018/01/04/194944)).

Our analyses would not be possible without GWAS and molecular data collection efforts by the referenced consortia and individuals. We are grateful to the many groups that have made data publicly available and accessible. 

The TWAS hub logo is from [André Luiz Gollo](https://thenounproject.com/andreluizgollo/collection/medical-outlined/?i=843273) and the Noun Project.

## What else can I read about TWAS?

| [Mancuso et al. 2018 biorxiv ](https://doi.org/10.1101/236869) | A method for fine-mapping credible sets of TWAS genes |
| [Barfield et al. 2018 Gen Epi](https://doi.org/10.1101/223263) | A method for distinguishing co-localization in TWAS tests |
| [Gusev et al. 2018 biorxiv](https://doi.org/10.1101/330613) | TWAS of ovarian cancer |
| [Mancuso et al. 2018 biorxiv](https://doi.org/10.1101/345736) | TWAS of prostate cancer |
| [Wu et al. 2018 Nat Genet](https://www.ncbi.nlm.nih.gov/pubmed/29915430) | TWAS of breast cancer |
| [Gusev et al. 2018 Nat Genet](https://www.ncbi.nlm.nih.gov/pubmed/29632383) | Integration of TWAS with chromatin features |
| [Mancuso et al. 2017 AJHG](https://www.ncbi.nlm.nih.gov/pubmed/28238358) | TWAS of 30 traits and methods for cross-trait analyses |
| [Gusev et al. 2016 Nat Genet](https://www.ncbi.nlm.nih.gov/pubmed/26854917) | Primary TWAS method paper |
{: .flat}

## Change Log

| 06/15/2018 | Updated with MDD, CD, IBD, UC, AD, reaction time, and verbal reasoning GWAS. |
| 06/10/2018 | 1st release, 324 traits. |
{: .flat}