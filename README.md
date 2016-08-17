# Fall-Detection

Introduction
------------
Elderly people tend to slip and fall in homes and remain unattended for a long time. 
If the affected person is not treated immediately, serious health issues including brain injuries occur. 
The proposed solution automatically detects humans falling, through cameras installed in homes, and sends notification to family members.

Requirements
------------
MATLAB R2013a

Usage 
-----
MATLAB command line
```matlab
falldetection <video_name>;
```
####Example
```matlab
falldetection video.mp4;
```
####Note
The video should be saved in '..\Fall-Detection\Video' folder.

Flowchart
---------
![Implemented Flowchart](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Flowchart")

Algorithm
---------

YouTube Demo Link
------------------
Demo of the project

<a href="http://www.youtube.com/watch?feature=player_embedded&v=LdoLniUSOaA
" target="_blank"><img src="http://img.youtube.com/vi/LdoLniUSOaA/0.jpg" 
alt="Youtube Video: Human Fall Detection" width="240" height="180" border="10" /></a>

Note
----
* Live transmission from the camera to the software is not supported. Instead, the data from the camera is first stored and then processed.
* The notification is sent to the user through an app installed on the phone. The apk file is not included in this repository.

Reference Paper
---------------
C.Rougier,J.MeunierFall,A.Arnaud and J.Rousseau. Detection from Human Shape and Motion History using Video Surveillance. *Proceedings of the 21st International Conference on Advanced Information Networking and Applications Workshops*,2007. 





