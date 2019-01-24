# FerretDiffusionTractTracingComparison
Comparing tractography and tract-tracing in the ferret brain

Preprint available on biorxiv:
Comparison between diffusion MRI tractography and histological tract-tracing of cortico-cortical structural connectivity in the ferret brain
C. Delettre, A. Messé, L-A. Dell, O. Foubet, K. Heuer, B. Larrat, S. Merieaux, J-F. Mangin, I. Reillo, C. de Juan Romero, V. Borrell, R. Toro, C. C. Hilgetag
https://www.biorxiv.org/content/10.1101/517136v2 


### scripts
#### data processing
scripts for the preprocessing and processing of the diffusion data
as well as for generating and normalizing the connectivity matrices.
for more details see readme.txt

#### data analysis
scripts for the computation of the correlations between the diffusion data and the tract-tracing data
as well as the different tests presented in the paper.
for more details see readme.txt

### data
connectivity matrices from diffusion tractography
for 6 tracttography pipelines: DTI, CSD and msmt CSD using deterministic and probabilistic tractography. Tractography performed with MRtrix3 (https://mrtrix.readthedocs.io/en/latest/)
tract-tracing data used from (Dell et al, 2018) on the ferret brain connectivity of the occipital (https://doi.org/10.1002/cne.24631), temporal (https://doi.org/10.1002/cne.24632) and posterior parietal cortices (https://doi.org/10.1002/cne.24630).
