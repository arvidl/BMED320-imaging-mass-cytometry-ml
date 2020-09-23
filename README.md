# BMED320: Methods in biomedical research
_BMED320-imaging-mass-cytometry-ml_

**Computational imaging and machine learning in biomedicine (BMED320)**

Our group is working at the Mohn Medical Imaging and Visualisation (MMIV) Centre on machine learning in medical imaging. We offer the opportunity to get into the methods and tools (e.g. Jupyter notebooks and Python programming) related to this research. See also the topics and teaching material at the virtual NordBioMedNet Summer School 2020: Computational Biomedicine - Imaging, machine learning and precision medicine (https://github.com/oercompbiomed/Seili-2020) that might interest you. 

### BMED320 project on Imaging Mass Cytometry and Machine Learning at Department of Biomedicine, UiB


# Setting up your system (preparation to the project)

**Follow the instructions at [Setting up your system](setup.md) (`setup.md`) to get ready**

### Browser
- Display and functionality might differ between browsers - we recommend using Google [Chrome](https://www.google.com/chrome) on all platforms

# Notebooks
The course is based on the Jupyter Notebook, a web-based framework for developing and presenting code-based projects (take a look at https://youtu.be/HW29067qVWk og https://youtu.be/2eCHD6f_phE for introductions to Jupyter Notebooks).

### IMPORTANT (for making your own notebooks for coding experiments without conflict)
Throughout the course you will work with notebooks that contain various material and programming tasks. We recommend that you *make a copy of our notebooks before you are editing them*. In this respect you might adopt the naming convention `my_[name_of_notebook].ipynb`. Remember also to start a new session with a `**git pull**` (things can have changed).


## Get started - test your environment
* [Python, Numpy, Pandas, Matplotlib, Cellpose, PyCaret and more](./test-notebooks): run through this notebook (`test-notebooks/1.0-test-cellpose.ipynb`) and  (`test-notebooks/2.0-test-pycaret.ipynb`) to check that your environment is OK.<br>

# Imaging Mass Cytometry 
(adapted from https://visikol.com/imaging-mass-cytometry)

**INTRODUCTION**

Imaging mass cytometry or CyTOF (Fluidigm) is a clever and powerful tool for leveraging mass spectroscopy to acquire imaging data from tissues with 40+ labels at the same time. The general premise of the technology is as follows:

- Traditional tissue slices on microscope slides are labeled with antibodies to highlight specific proteins of interest but instead of the antibodies being conjugated to fluorophores like they are in fluorescence microscopy, they are conjugated to metals that normally would not appear in vivo (e.g. palladium).
- After the tissues are labeled with these metal-conjugated antibodies, the slides are ablated with a laser in approximately 1 um2 pixels. The tissue from these pixels and associated metals are then passed through a mass spec which can quantitatively assess the presence and quantity of each metal in a pixel. After a pixel is ablated, another adjacent pixel is ablated within a 1000 x 1000 pixel field of view until all of the metals from each pixel have been passed through the mass spec.
- Using the mass spec data associated with each pixel, an image can then be created for each marker from the tissue.

## Imaging Flow Cytometry (IFC) at UiB

cf. [Flow Cytometry Core Facility](https://www.uib.no/en/clin2/flow) at UiB

**Flow cytometry** is a technology that measures and analyzes the optical properties of mono-dispersed single particles, such as cells, bacteria, picoplankton, microbeads, yeast, platelets, nuclei and other similarly-sized particles, passing single file through a focused laser beam.

An important feature of flow cytometry is that large numbers, for example thousands of particles per second, are analyzed and therefore provide a statistically significant picture of a specimen's physical and biochemical make-up.

At the core facility you also have access to the **Mass cytometer** the Helios from Fluidigm. This technology allows for the analysis of more than 42 parameters simultaneously on a single cell basis, to enable breakthrough discovery and comprehensive functional profiling applications.


## Imaging Mass Cytometry (IMC) at UiB

cf. [Hyperion - Image Mass Cytometry](https://www.uib.no/en/clin2/flow/120463/hyperion-image-mass-cytometry) at UiB

The [Hyperion^TM Imaging System](https://www.fluidigm.com/products/hyperion-imaging-system) is a high-parameter imaging system capable of analyzing 4 to 37 protein markers at subcellular resolution in fixed tissue sections or cell smears. With the ability to utilize up to 135 channels to detect additional parameters, the Hyperion Imaging System is ideal to meet researcher needs today and well into the future.

The Hyperion Imaging System is based on the HeliosTM mass cytometry platform. This high-dimensional imaging platform uses mass-tagged antibodies to markers alongside cell structural features in tissue and cell smears.

Mass-tagging involves separation of signals based on the differences in mass, resulting in distinct signals for each marker without the need for compensation associated with fluorometric techniques yet far more specific and sensitive than tag-free techniques.

The metal tags can be defined within 1 Da spatial resolution in tissue and cell smears, resulting in a unique spatial and parametric definition of the cells in situ. The system enables understanding of protein behavior and interactions to drive biological breakthroughs.

### For references see [[here](refs)]

### Workflow of imaging mass cytometry ([Bodenmiller lab](http://www.bodenmillerlab.com/research-2/imaging-mass-cytometry))
Imaging mass cytometry couples immunohistochemical and immunocytochemical methods with high-resolution laser ablation to CyTOF mass cytometry. Currently, the method allows the simultaneous imaging of 44 proteins and protein modifications at subcellular resolution; with the availability of additional isotopes, measurement of over 100 markers will be possible.

![Bodenmiller lab](http://www.bodenmillerlab.org/wp-content/uploads/2014/09/NMETH-A19779B_GiesenEtAl_CyTOF_Imaging_Figure1.jpg)
Workflow of imaging mass cytometry (Figure from Giesen et al., Nature Methods, 2014 Apr;11(4):417-22). Tissue sections are prepared for metal-chelated antibody labeling using IHC protocols. Then, tissue samples are positioned in a laser ablation chamber. The tissue is ablated and transported by a gas stream into the CyTOF for mass cytometry analysis. The measured isotope signals are plotted using the coordinates of each single laser shot, and a multidimensional tissue image is generated. Single-cell features and marker expression are determined, allowing the investigation of cell subpopulation properties within the analyzed tissue.

### Summary of Image Processing and Analysis Techniques in MCI (=IMC)
(from Baharlou et al. Front. Immunol., 14 November 2019 | https://doi.org/10.3389/fimmu.2019.02657)

(**A**) Following the acquisition of MCI, image processing is performed to denoise the images, perform single-cell segmentation to identify cell outlines, and to classify these cells based on marker expression. (**B**) One way of exploring cell composition between groups is to compare the change in the cell fractions. (**C**) Another way to explore cell composition is to classify patients as being positive and negative for a particular cell population. The co-occurrence of cells can be presented similar to what is presented here, and significance of co-occurrence can be identified using a chi-square test. (**D**) Differences in marker expression between patients can be visualized using a heatmap. (**E**) Cell morphology measurements can be used to explore cell phenotypes. (**F**) Cell-cell interactions can be measured using neighborhood analysis or point-process analysis. With a neighborhood analysis, percentage of significant images (i) or Z-scores (ii) of the cell-cell interactions can be represented as a heatmap, with significant associations associated with a more positive Z-score and significant avoidance is associated with a more negative Z-score. With a point-process analysis, an L function can be used to assess the significance of cell-cell interactions. The L function being above or below the gray envelope generated by bootstrapping corresponds to association and avoidance, respectively (iii). (**G**) One way of measuring cell or marker association with a marker is to classify cells as being near or far away from the border. A cell composition analysis can be used to explore differences, or differences in marker expression can be explored, as shown here.

![Image processing MCI](https://www.frontiersin.org/files/Articles/469030/fimmu-10-02657-HTML/image_m/fimmu-10-02657-g003.jpg)


## IMC Segmentation Pipeline (Bodenmiller Group)

- https://github.com/BodenmillerGroup/ImcSegmentationPipeline
- https://github.com/BodenmillerGroup/imctools  (`pip install imctools==2.0.1`)
- https://github.com/CellProfiler/CellProfiler  (https://cellprofiler.org)
- https://github.com/CellProfiler/CellProfiler-Analyst (https://cellprofileranalyst.org)
- https://github.com/BodenmillerGroup/ImcPluginsCP (IMC plugins to CellProfiler 3)


## Machine Learning

- PyCaret (https://pycaret.org) an open source, low-code machine learning library in Python that allows you to go from preparing your data to deploying your model within minutes in your choice of notebook environment.

## Hands-On Introductions

- https://github.com/BodenmillerGroup/IntroDataAnalysis
- http://www.cellpose.org (a generalist algorithm for cellular segmentation - [GitHub](https://github.com/MouseLand/cellpose))
