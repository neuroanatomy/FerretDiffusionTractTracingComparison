*** processall.sh
includes preprocessing and processing of the DWI data.
Will call preproc.sh which includes:
	* detection and exclusion of noisy volumes
	* LPCA denoising
	* Gibbs ringing correction
	* Eddy current correction
	* B1 bias correction

Will then call every individual tractography pipeline:
	* tract_dti.sh 			-- deterministic DTI tractography
	* tract_dti_prob.sh 		-- probabilistic DTI tractography
	* tract_csd_SD.sh		-- deterministic CSD tractography
	* tract_csd_iFOD2.sh		-- probabilistic CSD tractography
	* tract_msmt_csd_wmcsf_SD.sh	-- deterministic msmt CSD tractography
	* tract_msmt_csd_wmcsf.sh	-- probabilistic msmt CSD tractography

*** Connectivity matrices and average streamline length 
* computeBizleyConMat.py
computes matrices using the Bizley and King (2009) parcellation
extracts the parcels used for the comparison with the tract-tracing data

* normalizeMatrices_FLN.py & normalizeMatrices_FS.py
normalizes matrices with FLN or FS

