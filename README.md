# Scorpion: 2.5D IK Simulator
# [About](https://ruichenhe.github.io/Scorpion/)
A course project for *CSCI 5611: Animation and Planning in Games*. **Scorpian** is a 2.5D (simulate in 2D, visulize in 3D) Inverse Kinematic (IK) simulator. In the Scorpian, a scorpian like robot is simulated. It has two hands, with the tail been placed at the center without any movement (serve as the root of the scorpian). Whenever user press `r`, a random goal (represented as red box) will be generated at random location within reach distance of either hands (sometimes both ahdn won't be able to touch the goal). Using the IK solver, either hand or both hand (switch two modes by presseing `t`), will try to reach to the goal. When the goal is reached, it will become blue.

Note: The Scorpion project is extended from after-class IK activity.

## Author: *Ruichen He*

## Demo1
![](https://github.com/RuichenHe/Scorpion/blob/main/doc/Scorpion_demo1.gif)

<img src="{{ "doc/Scorpion_demo1.gif" | prepend: site.baseurl | prepend: site.url}}" alt="Scorpion_demo1" />

In the first demo gif, it shows a goal been generated within the reach distance of one hand, and the goal been reached by the hand eventually. In this demo gif, the following features have been presented:
+ **Single-arm IK (2D)** (20)
+ **Multi-arm IK (2D)** (20)
+ **3D Rendering & Camera** (10)

## Demo2
![](https://github.com/RuichenHe/Scorpion/blob/main/doc/Scorpion_demo2.gif)

<img src="{{ "doc/Scorpion_demo2.gif" | prepend: site.baseurl | prepend: site.url}}" alt="Scorpion_demo2" />

In the second demo gif, it shows how the simulation looks like without the joint limits. By comparing it with the first demo, it is clear that the simulation with the joint limits behave more like a scorpion. In this demo gif, the following features have been presented:
+ **Joint Limits** (20)

## Demo3
![](https://github.com/RuichenHe/Scorpion/blob/main/doc/Scorpion_demo3.gif)

<img src="{{ "doc/Scorpion_demo3.gif" | prepend: site.baseurl | prepend: site.url}}" alt="Scorpion_demo3" />

In the demo 3, it shows the user control of the root of the scorpion. By pressing `i`, `k`, `j`, `l`, user can move the scorpion towards different direction (Up, Down, Left, and Right, relative to the heading direction of the scorpion). In the meantime, the IK will be used to simulate the rest of the scorpion body to move towards the goal. In addition, by pressing `t`, scorpion can switch between single hand mode and double hand mode. In this demo gif, the following features have been presented:
+ **User Interaction** (10)
+ **Moving IK** (10)

## Difficulties
I think for 2D IK, the biggest difficulty is to orgnize all the component into a set of Class to make the whole system more generalizable to complicated robot structure (for instance, multi-arm). 

# Future Work

Due to the limit of time, only 2D simulation is implemented. Future works include:
+ 3D IK
+ Realistic shadow simulation
+ Skinned models

# Code
The source code is available to download [here](https://github.com/RuichenHe/Scorpion)



