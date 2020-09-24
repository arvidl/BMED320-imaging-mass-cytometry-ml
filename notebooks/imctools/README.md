# IMC tools

### Data format (_.mcd_)




### Data availability

Damond N et al. A Map of Human Type 1 Diabetes Progression by
Imaging Mass Cytometry. Cell Metabolism 2019;29:755–768. [[PDF](../../refs/Damiond_etal_A_Map_of_Human_Type_1_Diabetes_Progression_by_Imaging_Mass_Cytometry_Cell_Metabolism_2019.pdf)]
(see: https://www.cell.com/cell-metabolism/fulltext/S1550-4131(18)30691-0)


Data and code access: https://data.mendeley.com/datasets/cydmwsfztj/1  [5466 MB]

**Description**<br>
Data related to the publication: "Imaging Mass Cytometry Analysis
Sheds Light on Type 1 Diabetes Progression" (manuscript submitted to Cell Metabolism).

We used imaging mass cytometry to simultaneously image 37 biomarkers with single-cell and spatial resolution in pancreas sections from 12 human donors at different stages of type 1 diabetes.

CODE:<br>
- Python script for coordinate transformation
- Functions for custom histoCAT neighborhood analysis

DATA:<br>
- Single-cell data
- Islet-level data
- Relationships between cells and islets

IMAGES:<br>
- Image stacks (37 channels) for all areas imaged (numbers indicate nPOD case IDs)
- Panel file with information related to antibodies and metal tags
- Metadata file with patient information for all images


https://data.mendeley.com/datasets/cydmwsfztj/1

--> Cells.7z  (1.63 GB)

Q: How can I unpack .7z files via MacOS terminal?<br>
A: You can install p7zip with Homebrew.
```
brew install p7zip
7za x Cells.7z
```

------------------
!! We forget about the mcdlib for now !!
(cf. https://github.com/BodenmillerGroup/mcdlib)

**Installation**
```
git clone --recursive https://github.com/BodenmillerGroup/mcdlib.git
mkdir mcdlib/cmake-build-release
cd mcdlib/cmake-build-release
cmake -DCMAKE_BUILD_TYPE=Release ..
make
sudo make install
sudo ldconfig
```
Note: if you experience troubles while building the library (more specifically, when linking mcdlib to the OME libraries), this likely happens because of outdated/broken CMake files provided by the Open Microscopy Environment (OME) team  [I skip OMEFiles in the CmakeLists.txt, still problems to compile]

```
if (ENABLE_OMETIFF_SUPPORT)
    find_package(OMEFiles REQUIRED)
    target_link_libraries(mcd PUBLIC OME::Files)
    target_compile_definitions(mcd PUBLIC -DOMETIFF_SUPPORT_ENABLED)
endif ()
```
See also: https://gitlab.com/codelibre/ome/ome-files-cpp

For interactive/scripting usage, this is a Python 3 example:
```
import mcdpy
mcd = mcdpy.MCDFile('/path/to/file')

# full metadata access
meta = mcd.readMetadata()
first_slide = meta.slides[0]
print(first_slide.properties['SwVersion'])
print(meta.schemaXML)

# slide image extraction
mcd.saveSlideImage(first_slide, '/path/to/file')

# panorama image extraction
first_panorama = first_slide.panoramas[0]
mcd.savePanoramaImage(first_panorama, '/path/to/file')

# before/after acquisition image extraction
first_region = first_panorama.regions[0]
first_acquisition = first_region.acquisitions[0]
mcd.saveAcquisitionImage(first_acquisition, '/path/to/file', mcdpy.AcquisitionImageType.BEFORE)
mcd.saveAcquisitionImage(first_acquisition, '/path/to/file', mcdpy.AcquisitionImageType.AFTER)

# acquisition data export to OME-TIFF
data = mcd.readAcquisitionData(first_acquisition)
data.writeOMETIFF('/path/to/file.ome.tiff')
data.writeOMETIFFCompressed('/path/to/file.ome.tiff', 'LZW')

# in-memory acquisition data access
first_channel = first_acquisition.channels[0]
channel_data = data.findChannelData(first_channel)
raw_channel_data = channel_data.data
```


### Data viewer (_MCD Viewer_)
(cf. https://www.fluidigm.com/binaries/content/documents/fluidigm/resources/mcd-viewer-v1.0.560.6-user-guide/mcd-viewer-v1.0.560.6-user-guide/fluidigm%3Afile)

**MCD**<br>
 (.mcd) files are created by CyTOF Software 6.7 and later.
MCD files contain imaging data for one or more regions of interest.

**Text**<br>
Tab-delimited text (.txt) files created by CyTOF Software 6.7 and later. Text files contain imaging data for individual regions of interest (ROIs). The header row is formatted Start_push, End_push, Pushes_duration, X, Y, Z, channel(label):

**Channel list**<br>
The channel list displays all channels acquired for the selected ROI. The channel list populates after a data file is opened and a panorama and ROI are selected.


**MCD Viewer** is post-acquisition data processing software that allows users to visualize, review, and export Imaging Mass Cytometry data acquired with the Hyperion Imaging System and CyTOF Software 6.7 and later.
- Create and save merged ion images to 8- or 16-bit color TIFF files for presentation and
publication purposes.
- Export raw data to the following formats for additional processing and analysis with
third-party software:
  - Single-page or multipage 16-bit grayscale OME-TIFF (.ome.tiff)
  - Single-page or multipage 32-bit grayscale OME-TIFF (.ome.tiff)
  - Text (.txt)

### Data requirement for further analysis
(cf. https://github.com/BodenmillerGroup/ImcSegmentationPipeline/blob/development/scripts/imc_preprocessing.ipynb)

We assume that _each .mcd acquisition_ - and optionally _all .txt files corresponding to this '.mcd' acquisition_ - are saved in one a seperate .zip folder. If not, zip folders of individual mcd files can be made manually (check they contain same filetype as example data).


### `imctools` pre-processing example
(cf. https://github.com/BodenmillerGroup/imctools)

```
imctools is often used from Jupyter as part of the pre-processing pipeline, mainly using the converters wrapper functions. Please check the following example as a template.

Further imctools can be directly used as a module:

from imctools.io.mcd.mcdparser import McdParser

fn_mcd = "/home/vitoz/Data/varia/201708_instrument_comp/mcd/20170815_imccomp_zoidberg_conc5_acm1.mcd"

parser = McdParser(fn_mcd)

# Get original metadata in XML format
xml = parser.get_mcd_xml()

# Get parsed session metadata (i.e. session -> slides -> acquisitions -> channels, panoramas data)
session = parser.session

# Get all acquisition IDs
ids = parser.session.acquisition_ids

# The common class to represent a single IMC acquisition is AcquisitionData class.
# Get acquisition data for acquisition with id 2
ac_data = parser.get_acquisition_data(2)

# imc acquisitions can yield the image data by name (tag), label or index
channel_image1 = ac_data.get_image_by_name('Ir191')
channel_image2 = ac_data.get_image_by_label('Histone_phospho_125((2468))Eu153')
channel_image3 = ac_data.get_image_by_index(7)

# or can be used to save OME-TIFF files
fn_out ='/home/vitoz/temp/test.ome.tiff'
ac_data.save_ome_tiff(fn_out, names=['Ir191', 'Yb172'])

# save multiple standard TIFF files in a folder
ac_data.save_tiffs("/home/anton/tiffs", compression=0, bigtiff=False)

# as the mcd object is using lazy loading memory maps, it needs to be closed
# or used with a context manager.
parser.close()
```
