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





## A Brief Introduction for how to use ILCSoft packages
Here is just a brief introduction for explaning the meaning and the usage of different packages of ILCSoft. The detail manual of each package can be found in their own README file.

### Work flow for a new analysis 
When one wants to analyse a physics process, the typical work flow may look as following:

1. Generate monte-carlo particles for that physics process with a generator, e.g. Whizard+Pythia, which will generate stdhep files with n00 MB/file, the size of file depanding on the setting of the generator.
2. Split a stdhep file to many small files (xx MB/file). Here the "split"  and the "merge" in step 5 is not necessary for everytime. But in the next step, the simulation process will store huge information for each events, if you don't split the file here, the final file may be too large.
3. Simulate particle samples with Mokka/DD4hep, which will generate "slcio" files with GB/file. The slcio file is a standard file for ILCSoft.
4. Reconstruct particle information with Marlin processors, which will generate two kinds of files -- "DST" files and "REC" files.
5. Merge those "DST"/"REC" files into one or several bigger files. The "REC" file contains all infomation for generating, simulation and reconstruction. The "DST" file only contain some of them. Usually, the "DST" file is what we use for analysis, but you can also check the "REC" file for more details.
6. Write a steering file for Marlin platform, with processors supplied by ILCSoft or your own processors, to complete your analysis. 
7. In most of the cases, you need to write your own processor.

In the following, we will explain each steps.

### whizard basic introduction
For a member of ILC group, Whizard is usually be installed on the server, try to find it and install it on your account. Here is some tips:
1. every time when you want to change the model or generate a new physics channel, you should change whizard.prc file and recompile whizard.
   The model file is in the ./conf/models/xxx.mdl

2. after compile the whizard, you can use it following these steps
	- make a new folder
	- make a soft link to the whizard executable program "whizard", which should in $WHIZARD_PATH/bin/whizard
	- put whizard.in, whizard.cut1, whizard.cut5, whizard.prc, whizard.mdl files in the folder.
	- edit whizard.in, whizard.cut1 and whizard.cut5
	- run whizard with  ./whizard

For other user, Whizard is not included in the ILCSoft package, here you can download [Whizard](https://whizard.hepforge.org/), and find the manual.


### how to simulate events
Let's suppose that you already know how to use Whizard, and have generated a stdhep file. Then you can simulate the events with "Mokka/DD4Hep".



### The events samples in ILC group
In ILC group, many SM and new physics event samples have already been generated and simulated.
The detail information of the SM event samples can be found at 
http://ilfsoft.desy.de/dbd/generated/

The sample file name in the ILC group will look like

rv01-19-04_lcgeo.sv01-19-04_lcgeo.mILD_l4_v02.E250-TDR_ws.I106479.Pe2e2h.eL.pR.n001_012.d_rec_00008603_6.slcio

|short name | meaning  | example | explaination |
|:---------:|:--------:|:-------:|:------------:|
|rv | reconstruction software version|  01-19-04_lcgeo |                                                    |
|sv | simulation     software version|  01-19-04_lcgeo |                                                    |
|m  | ILD detector   software version|  ILD_l4_v02     |  ILD detector version                              | 
|E  | collider energy                |  250-TDR_ws     |  250 GeV collider                                  |
|I  | Proc ID                        |  106479         |  each process has a unique id                      |   
|P  | process name                   |  e2e2h          |  ee -> zh then z-> mu mu process                   | 
|e  | beam polorization              |  eL             |  electron is left-handed                           | 
|p  | beam polorization              |  pR             |  positron is right-handed                          | 
|n  | job number                     |  001_012        |  the number for simulation group submitting the job|
|d_ | Job ID                         |  rec_00008603_6 |  this is a rec file                                |

In principle, one can re-generate all the same events with the same software setting.




### Basic command to check the events 
When one generate some event samples, the first thing he/she wants to do usually is checking the events with some basic straight-forward tools. 
The ILCSoft provides many tools to check them for different purposes.

1. Suppose you only have a .stdhep file, which is very easy generated by many generators, then you can transfer a .stdhep file to a .slcio file with
	
	- stdhepjob xxx.stdhep xxx.slcio 1 
	
2. The file after simulation is always a "slcio" file, you can check the "slcio" file with 
	- anajob xxx.slcio              --- for basic information (total events number, how many collections, what collections, the meaning for collections will be explained in the "slcio structure section")
	- dumpevent xxx.slcio n | less  --- for details of the n th events (The detail information for each collections)
3. check the event in the detector, the GearOutput.xml can be found in "ILDConfig" folder, which contains the ILD detector information.
	- ced2go -d GearOutput.xml -v DSTViewer xxx.slcio   --- for DST file   
	- ced2go -d GearOutput.xml  xxx.slcio               --- for REC file






### How to run Marlin for analysis
When you have the events, you can analyse them in the Marlin platform.
To run Marlin, first you need a steering file, you can create a typical steering file by a command

` Marlin mysteer.xml`

In this steering file, it contains many processors supplied by ILCSoft. But it is so complicated, we can use a simple one for explaination.

```
<marlin>
	<execute>
		<processor name="MyIsolatedLeptonTaggingProcessor"/>
	</execute>

	<global>
		<parameter name="LCIOInputFiles">
		</parameter>
		<parameter name="GearXMLFile"> GearOutput.xml </parameter> 
		<parameter name="MaxRecordNumber" value="0" />  
		<parameter name="SkipNEvents" value="0" />  
		<parameter name="SupressCheck" value="false" />  
		<parameter name="Verbosity" options="DEBUG0-4,MESSAGE0-4,WARNING0-4,ERROR0-4,SILENT">WARNING</parameter>
		<parameter name="AllowToModifyEvent" value="true" />
	</global>


	<processor name="MyIsolatedLeptonTaggingProcessor" type="IsolatedLeptonTaggingProcessor">
		<parameter name="CosConeLarge" type="float">0.95 </parameter>
		<parameter name="CosConeSmall" type="float">0.98 </parameter>
		<parameter name="CutOnTheISOElectronMVA" type="float"> 0.5 </parameter>
		<parameter name="CutOnTheISOMuonMVA" type="float">0.7 </parameter>
		<parameter name="DirOfISOElectronWeights" type="string"> /afs/desy.de/project/ilcsoft/sw/x86_64_gcc48_sl6/v01-17-09/MarlinReco/v01-14/Analysis/IsolatedLeptonTagging/example/isolated_electron_weights </parameter>
		<parameter name="DirOfISOMuonWeights" type="string"> /afs/desy.de/project/ilcsoft/sw/x86_64_gcc48_sl6/v01-17-09/MarlinReco/v01-14/Analysis/IsolatedLeptonTagging/example/isolated_muon_weights </parameter>
		<parameter name="InputPandoraPFOsCollection" type="string" lcioInType="ReconstructedParticle"> PandoraPFOs </parameter>
		<parameter name="IsSelectingOneIsoLep" type="bool"> false </parameter>
		<parameter name="MinPForElectron" type="float">5 </parameter>
		<parameter name="MinPForMuon" type="float">5 </parameter>
		<parameter name="MinEOverPForElectron" type="float">0.5 </parameter>
		<parameter name="MaxEOverPForElectron" type="float">1.3 </parameter>
		<parameter name="MaxEOverPForMuon" type="float">0.3 </parameter>
		<parameter name="MinEecalOverTotEForElectron" type="float">0.9 </parameter>
		<parameter name="MinEyokeForMuon" type="float">1.2 </parameter>
		<parameter name="MaxD0SigForElectron" type="float">50 </parameter>
		<parameter name="MaxD0SigForMuon" type="float">5 </parameter>
		<parameter name="MaxZ0SigForElectron" type="float">5 </parameter>
		<parameter name="MaxZ0SigForMuon" type="float">5 </parameter>
		<parameter name="OutputIsoLeptonsCollection" type="string" lcioOutType="ReconstructedParticle"> Isoleps </parameter>
		<parameter name="OutputPFOsWithoutIsoLepCollection" type="string" lcioOutType="ReconstructedParticle"> PFOsWithoutIsoleps </parameter>
		<parameter name="Verbosity" type="string"> SILENT </parameter>
	</processor>

</marlin>

```
The steering file uses XML language, which is a markup language, here is the usage of [xml](http://www.xmlfiles.com/xml/xml_usedfor.asp). 

For the steering file, it begins and ends with </marlin> *** </marlin>. Between this, it contains three section  	
```
<execute>
    <processor name="[You choose a name to describe the processor, e.g.] NameA"/>
    # ...
    # all the processors that you want to use, they will be executed one by one.
</execute>

<global>
    # some global parameters, for example, the input file name.
    <parameter name="LCIOInputFiles">
         #input filenames and directories
	</parameter>
	
	#The detector structure file
	<parameter name="GearXMLFile"> GearOutput.xml </parameter> 
	...
</global>

<processor name="NameA" type="[The processor name, e.g.] IsolatedLeptonTaggingProcessor">
    # This is for find Isolated Lepton in the events samples.
    # You need to supply the necessary parameters for this processor. e.g.
    <parameter name="CosConeLarge" type="float">0.95 </parameter>
    # ...
</processor>

```
In this example, you can get two out put collection "Isoleps" and "PFOsWithoutIsoleps", they can be used for further analysis. In some other processor, e.g. lctuple (which change the information in a slcio file into a root file), you can get a root file as the output.

### The Marlin processor


You can check which marlin processor library has been loaded by a bash command

`echo $MARLIN_DLL`


A summary for Marlin processor.  More to be added...


### How to create a new Marlin processor
   The most easy way to create a new Marlin processor is

   ` ./copy_new_processor.sh  old_processor_directory   new_processor_name`

   This script can be decomposed by following steps:
   
   - You'd better copy an old processer with .cc and .h file into a new folder and change the processer, instead of rewritting all of them.
   - Change the processor class name into a new one!! 
   NOTE: this is important, or it may conflict with existed processors.
   - Put ./action.sh into the same folder, change the PROJECTNAME in the action, and run
   ./bin/action.sh
   - When running this script, five folders will be created

    |   folder   |  meaning                |
    |:----------:|:-----------------------:|
    |  build     |  all compling file      |
    |  src       |  source file            |
    |  include   |  head file              |
    |  xml       |  steering file          |
    |  lib       |  your processor library |
    |  bin       |  execute file           |

   - go to xml folder, a default steering file has been created, change this steering file with the processors you want, then run it with
   Marlin mysteer.xml
   - in the next time, when you change something for this processor and need to recompile it, just run ./bin/action.sh.





### Slcio file structure
   When you need to write a new Marlin processor, you have to know the structure of the slcio file.
   You can check the slcio file structure with anajob for a general information or dumpevent for details.
   The following are the generally structure of a slcio file, the first list is the name that you can invoke them in your program, The second 
   list is their types.

   | Collection Name              | Collection Type       | Explanation|
   |:----------------------------:|:---------------------:|:----------:|
   | BCAL                         | CalorimeterHit        |         |
   | BeamCalCollection            | SimCalorimeterHit     |         |
   | BuildUpVertex                | Vertex                |         |
   | BuildUpVertex_RP             | ReconstructedParticle |         |
   | BuildUpVertex_V0             | Vertex                |         |
   | BuildUpVertex_V0_RP          | ReconstructedParticle |         |
   | ClupatraTrackSegments        | Track                 |         |
   | ClupatraTracks               | Track                 |         |
   | DistilledPFOs                | ReconstructedParticle |         |
   | EcalBarrelCollection         | SimCalorimeterHit     |         |
   | EcalEndcapRingCollection     | SimCalorimeterHit     |         |
   | EcalEndcapsCollection        | SimCalorimeterHit     |         |
   | EcalEndcapsCollectionDigi    | CalorimeterHit        |         |
   | EcalEndcapsCollectionGapHits | CalorimeterHit        |         |
   | EcalEndcapsCollectionRec     | CalorimeterHit        |         |
   | EcalEndcapsRelationsSimDigi  | LCRelation            |         |
   | EcalEndcapsRelationsSimRec   | LCRelation            |         |
   | FTDCollection                | SimTrackerHit         |         |
   | GammaGammaCandidateEtaPrimes | ReconstructedParticle |         |
   | GammaGammaCandidateEtas      | ReconstructedParticle |         |
   | GammaGammaCandidatePi0s      | ReconstructedParticle |         |
   | GammaGammaParticles          | ReconstructedParticle |         |
   | HCalBarrelRPCHits            | SimCalorimeterHit     |         |
   | HCalECRingRPCHits            | SimCalorimeterHit     |         |
   | HCalEndcapRPCHits            | SimCalorimeterHit     |         |
   | HcalBarrelRegCollection      | SimCalorimeterHit     |         |
   | HcalEndcapRingCollection     | SimCalorimeterHit     |         |
   | HcalEndcapsCollection        | SimCalorimeterHit     |         |
   | LCAL                         | CalorimeterHit        |         |
   | LHCAL                        | CalorimeterHit        |         |
   | LHCalCollection              | SimCalorimeterHit     |         |
   | LumiCalCollection            | SimCalorimeterHit     |         |
   | MCParticle                   | MCParticle            |         |
   | MCTruthMarlinTrkTracksLink   | LCRelation            |         |
   | MUON                         | CalorimeterHit        |         |
   | MarlinTrkTracks              | Track                 |         |
   | MarlinTrkTracksMCTruthLink   | LCRelation            |         |
   | PandoraClusters              | Cluster               |         |
   | PandoraPFANewStartVertices   | Vertex                |         |
   | PandoraPFOs                  | ReconstructedParticle |         |
   | PrimaryVertex                | Vertex                |         |
   | PrimaryVertex_RP             | ReconstructedParticle |         |
   | RelationBCalHit              | LCRelation            |         |
   | RelationLHcalHit             | LCRelation            |         |
   | RelationLcalHit              | LCRelation            |         |
   | RelationMuonHit              | LCRelation            |         |
   | SETCollection                | SimTrackerHit         |         |
   | SETSpacePointRelations       | LCRelation            |         |
   | SETSpacePoints               | TrackerHit            |         |
   | SETTrackerHitRelations       | LCRelation            |         |
   | SETTrackerHits               | TrackerHitPlane       |         |
   | SITCollection                | SimTrackerHit         |         |
   | SITTrackerHitRelations       | LCRelation            |         |
   | SITTrackerHits               | TrackerHitPlane       |         |
   | SiTracks                     | Track                 |         |
   | SubsetTracks                 | Track                 |         |
   | TPCCollection                | SimTrackerHit         |         |
   | TPCLowPtCollection           | SimTrackerHit         |         |
   | TPCSpacePointCollection      | SimTrackerHit         |         |
   | TPCTrackerHitRelations       | LCRelation            |         |
   | TPCTrackerHits               | TrackerHit            |         |
   | VXDCollection                | SimTrackerHit         |         |
   | VXDTrackerHitRelations       | LCRelation            |         |
   | VXDTrackerHits               | TrackerHitPlane       |         |
   | YokeBarrelCollection         | SimCalorimeterHit     |         |
   | YokeEndcapsCollection        | SimCalorimeterHit     |         |

   The most common used is MCParticle and PandoraPFOs. 
   For MCParticle, the detail information are

   |[id]| index | PDG | px, py, pz | px_ep, py_ep, pz_ep | energy | gen | [simstat] | vertex x, y, z | endpoint x, y, z | mass | charge | spin | colorflow | [parents] - [daughters]|
   
   You can use the command like getPDG() to get the information of a MCParticle.

   For PandoraPFOs, the detail information are

   |[id]| com | type | momentum | energy | mass | charge | position ( x,y,z ) | pidUsed | GoodnessOfPID | covariance( px,py,pz,E ) | particles([id]) | tracks ([id]) | clusters ([id]) | particle ids ([id],PDG,(type)) | vertices|

   The way to call this variables can be found at [here](http://lcio.desy.de/v02-09/doc/doxygen_api/html/namespaces.html), which is all the c++ API for lcio.



### How to program for a new Marlin processor
Need to add this...









