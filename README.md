# iLCSoft Documentation

This package provides some minimal documentation for the iLCSoft project on GitHub.
You can find more details about ilcsoft itself at:

- [http://ilcsoft.desy.de/portal](http://ilcsoft.desy.de/portal)


We are currently in a transition phase of moving our software packages from 
the [DESY svn](https://svnsrv.desy.de/websvn) to GitHub.

## List of packages maintained on GitHub

All packages in the iLCSoft GitHub project are now fully maintained on GitHub.
Some remaining packages, e.g. for test beams, are still maintained on svn.
Contact us, if you want your package to also be included in the iLCSoft GitHub project.

Some ilcsoft packages are maintained in related GitHub projects:

- [AidaSoft/DD4hep](https://github.com/AidaSoft/DD4hep)
- [AidaSoft/aidaTT](https://github.com/AidaSoft/aidaTT)
- [lcfiplus/LCFIPlus](https://github.com/lcfiplus/LCFIPlus)
- [FCALSW/FCalClusterer](https://github.com/FCALSW/FCalClusterer)

### Overview of Open Issues and PullRequests

[Dashboard](https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+user%3AiLCSoft+user%3AAIDASoft+user%3AFCALSW+user%3APandoraPFA)

## Contributing to iLCSoft packages

If you want to contribute to iLCSoft packages on GitHub, fork the corresponding
project and create a pull request with your proposed changes. Please see the
[contribution guidelines](.github/CONTRIBUTING.md).

### Tutorial for using git (and GitHub) 

If you are new to git and GitHub, have a look at this tutorial:

- [https://github.com/andresailer/tutorial](https://github.com/andresailer/tutorial)



##work flow for ILC group

- mc-particles with Whizard+Pythia, which will generate stdhep files with n00 MB/file.
- split a stdhep file to many small files.
- simulated-particles with Mokka/DD4hep, which will generate slcio files with xGB/file.
- reconstructed particles with Marlin processors, which will generate two kinds of files -- "DST" files and "REC" files.
- merge those "DST"/"REC" files into one big file. The "REC" file contains all infomation for generating, simulation and reconstruction. The "DST" file only contain some of them.
- The "DST" file is what we usually use.




## The meaning of the file name
e.g.
rv01-19-04_lcgeo.sv01-19-04_lcgeo.mILD_l4_v02.E250-TDR_ws.I106479.Pe2e2h.eL.pR.n001_012.d_rec_00008603_6.slcio
rv---reconstruction software version, here is 01-19-04_lcgeo
sv---simulation     software version, here is 01-19-04_lcgeo 
m ---ILD version                      here is ILD_l4_v02      
E ---collider energy                  here is 250-TDR_ws      , 250 GeV collider
I ---Proc ID                          here is 106479          , each process has a unique id 
P ---process name                     here is e2e2h           , ee -> zh, z->mu mu process
e ---beam polorization                here is eL              , electron is left-handed
p ---beam polorization                here is pR              , positron is right-handed
n ---job number                       here is 001_012         , the number for simulation group submitting the job
d_---Job ID                           here is rec_00008603_6  , this is a rec file

The information of event samples can be found at 
http://ilfsoft.desy.de/dbd/generated/




## Basic command 
After installing the ILCSoft, there will be some tools for basic straight-forward checking the events.
Suppose you already have a .stdhep file, then
- transfer a .stdhep file to a .slcio file
    stdhepjob *.stdhep *.slcio 1
- check .slcio
   anajob *.slcio
   dumpevent *.slcio n | less
- check the event in the detector
   ced2go -d GearOutput.xml -v DSTViewer *.slcio   --- for DST file
   ced2go -d GearOutput.xml  *.slcio               --- for REC file






## how to write a new Marlin processor
   The most easy way is
     ./copy_new_processor.sh  old_processor_directory   new_processor_name

This script can be decomposed by following steps:
- you would better copy an old processer with .cc and .h file into a new folder and change the processer, instead of rewritting all of them.
- change the processor class name into a new one!! 
    NOTE: this is important, or it may conflict with existed processors.
- put ./action.sh into the same folder, change the PROJECTNAME in the action, and run
   ./action.sh
- when running this script, five folders will be created
   build   --- all compling file
   src     --- source file
   include --- head file
   xml     --- steering file
   lib     --- your processor library
- go to xml folder, a default steering file has been created, change this steering file with the processors you want, then run it with
   Marlin mysteer.xml





## slcio file structure
You can check the slcio file structure with anajob for a general information or dumpevent for details.
The following are the generally structure of a slcio file, the first list is the name that you can invoke them in your program, The second 
list is their types.

BCAL                          CalorimeterHit                  
BeamCalCollection             SimCalorimeterHit               
BuildUpVertex                 Vertex                          
BuildUpVertex_RP              ReconstructedParticle           
BuildUpVertex_V0              Vertex                          
BuildUpVertex_V0_RP           ReconstructedParticle           
ClupatraTrackSegments         Track                           
ClupatraTracks                Track                           
DistilledPFOs                 ReconstructedParticle           
EcalBarrelCollection          SimCalorimeterHit               
EcalEndcapRingCollection      SimCalorimeterHit               
EcalEndcapsCollection         SimCalorimeterHit               
EcalEndcapsCollectionDigi     CalorimeterHit                  
EcalEndcapsCollectionGapHits  CalorimeterHit                  
EcalEndcapsCollectionRec      CalorimeterHit                  
EcalEndcapsRelationsSimDigi   LCRelation                      
EcalEndcapsRelationsSimRec    LCRelation                      
FTDCollection                 SimTrackerHit                   
GammaGammaCandidateEtaPrimes  ReconstructedParticle           
GammaGammaCandidateEtas       ReconstructedParticle           
GammaGammaCandidatePi0s       ReconstructedParticle           
GammaGammaParticles           ReconstructedParticle           
HCalBarrelRPCHits             SimCalorimeterHit               
HCalECRingRPCHits             SimCalorimeterHit               
HCalEndcapRPCHits             SimCalorimeterHit               
HcalBarrelRegCollection       SimCalorimeterHit               
HcalEndcapRingCollection      SimCalorimeterHit               
HcalEndcapsCollection         SimCalorimeterHit               
LCAL                          CalorimeterHit                  
LHCAL                         CalorimeterHit                  
LHCalCollection               SimCalorimeterHit               
LumiCalCollection             SimCalorimeterHit               
MCParticle                    MCParticle                      
MCTruthMarlinTrkTracksLink    LCRelation                      
MUON                          CalorimeterHit                  
MarlinTrkTracks               Track                           
MarlinTrkTracksMCTruthLink    LCRelation                      
PandoraClusters               Cluster                         
PandoraPFANewStartVertices    Vertex                          
PandoraPFOs                   ReconstructedParticle           
PrimaryVertex                 Vertex                          
PrimaryVertex_RP              ReconstructedParticle           
RelationBCalHit               LCRelation                      
RelationLHcalHit              LCRelation                      
RelationLcalHit               LCRelation                      
RelationMuonHit               LCRelation                      
SETCollection                 SimTrackerHit                   
SETSpacePointRelations        LCRelation                      
SETSpacePoints                TrackerHit                      
SETTrackerHitRelations        LCRelation                      
SETTrackerHits                TrackerHitPlane                 
SITCollection                 SimTrackerHit                   
SITTrackerHitRelations        LCRelation                      
SITTrackerHits                TrackerHitPlane                 
SiTracks                      Track                           
SubsetTracks                  Track                           
TPCCollection                 SimTrackerHit                   
TPCLowPtCollection            SimTrackerHit                   
TPCSpacePointCollection       SimTrackerHit                   
TPCTrackerHitRelations        LCRelation                      
TPCTrackerHits                TrackerHit                      
VXDCollection                 SimTrackerHit                   
VXDTrackerHitRelations        LCRelation                      
VXDTrackerHits                TrackerHitPlane                 
YokeBarrelCollection          SimCalorimeterHit               
YokeEndcapsCollection         SimCalorimeterHit               

The most common used is MCParticle and PandoraPFOs. 
For MCParticle, the detail information are
[id]| index | PDG | px, py, pz | px_ep, py_ep, pz_ep | energy | gen | [simstat] | vertex x, y, z | endpoint x, y, z | mass | charge | spin | colorflow | [parents] - [daughters]

For PandoraPFOs, the detail information are

[id]| com | type | momentum | energy | mass | charge | position ( x,y,z ) | pidUsed | GoodnessOfPID | covariance( px,py,pz,E ) | particles([id]) | tracks ([id]) | clusters ([id]) | particle ids ([id],PDG,(type)) | vertices

The way to call this variables can be found at http://lcio.desy.de/v02-09/doc/doxygen_api/html/namespaces.html, which is all the c++ API for lcio.






## whizard basic introduction
every time when you want to change the model or generate a new physics channel, you should change whizard.prc file and recompile whizard.
	The model file is in the ./conf/models/*.mdl

after compile the whizard, you can use it following these steps
  - make a new folder
  - make a soft link to the whizard executable program "whizard", which should in $WHIZARD_PATH/bin/whizard
  - put whizard.in, whizard.cut1, whizard.cut5, whizard.prc, whizard.mdl files in the folder.
  - edit whizard.in, whizard.cut1 and whizard.cut5
  - run whizard with  ./whizard



   



