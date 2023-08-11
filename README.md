# Data Acquire & Stimulation Systems (DASS):

Sketches (**Arduino**) & Scripts (**MATLAB**) to acquire data (images &signals) and stimualte optic systems (optogenetics & photochemistry)
in behavior neuroscience projects

## Sketches for Arduino

Hardware: 
- Arduino UNO (or equivalent)
- LED Driver (e.g. Thorlabs DC1200 or LEDD18 with TTL Trigger input)

### Stimuli TTL squared trains

Sketches:

- **TTL_cont_Train**

- **TTL_cont_Train_B**

![Examples: bilateral or double stimulation](/Documentation/Figures/Slide1.jpg)


### Text trigger to send TTL squared stimulus

Sketches:

- **TTL_single_pulse**

![Example: Optostimulation and electrical recording](/Documentation/Figures/Slide2.jpg)

## Scripts for MATLAB for *video* data acuisition

Hardware (one or two cams) and single setup (sequential mice recordings, i.e. set, record, replace, record):

- PS3 Eye Camera (Infrared)
- USB Webcam

**First of all**, run `>>Import_Scripts`

### Single Camera for N min recordings (e.g. for Open Field)

- Run `>>OpenField_SingleREC` and fill parametes requests.

Videos will be sotirde in a folder above repository: at *\Open_Field_Videos\*

### Single Camera recordings of sequential multiple animals and fixed intervals (e.g. Abnormal Involuntary Movements)

- Run `>>AIMs_Video_Recording` and fill parametes requests.

Example: TO assess Abnormal Involuntary Movements (AIMs) of L-DOPA Induced Dyskinesia (LID)

Videos will be sotirde ina folder above this repository: at *\AIMs_Cylinder_Videos\*

![Diagram and schema for single camera recordings](/Documentation/Figures/Slide3.jpg)

### Double Camera  recordings of sequential multiple animals and fixed intervals

- Run `>>AIMs_2Cams_Recording` and fill parametes requests.

Example: TO assess Abnormal Involuntary Movements (AIMs) of L-DOPA Induced Dyskinesia (LID)Diet

Videos will be sotirde ina folder above this repository: at *\AIMs_Cylinder_Videos\*

TimeStamps require postprocessing of the videos and trim them (in construction)

![Diagram and schema for two-camera recordings](/Documentation/Figures/Slide4.jpg)
