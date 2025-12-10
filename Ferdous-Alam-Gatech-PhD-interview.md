发言人 1  
Hi professor Alan. 
发言人 1  
Hi professor Alan. I think your mic is off. Yes, no. 
发言人 2  
no. 
发言人 1  
sorry's fine. 
发言人 2  
can you hear me now? 
发言人 1  
Yeah, clearly . 
发言人 2  
okay great, Hi I'm fedo and nice to meet you How do you pronounce your name? 
发言人 1  
You can just call me Chen I'm Chen Zhu, yes. 
发言人 2  
okay, yes Je okay, great, Okay then first of all, thank you for your email and you probably know I am starting a new lab at Georgia Tech, so just like how the next 30 minutes are going to pan out, we maybe we can start with some of your background, like your very brief intro to your past work and future interest, and then I will ask a couple of follow up questions and finally I will try to give you some idea about why what I'm going to work on and what would be like, you know, the main ideas behind the lab and finally we'll talk about a couple of logistics does that sound good? 
发言人 1  
Yes, perfect, that's good. 
发言人 2  
okay, perfect, okay. 
发言人 1  
I prepared a presentation can I share the screen. 
发言人 2  
Yeah, please feel free to go ahead, Okay. 
发言人 1  
so I just go go through it very quick briefly, right? 
发言人 2  
Yeah, that would be great. 
发言人 1  
okay. 
发言人 1  
Can I see my screen sharing right now? 
发言人 2  
Yes, I can see your screen. 
发言人 1  
Okay, perfect. Okay, so, hi Professor Allen, my name is J Zhu and my master is graduate from Tsinghua University, which is the top university in China mainland and a major in mechanical engineering with a good GPA, 3.86 and ranking in 17th. And my master's thesis, doing the research on chattar monitoring and suppression in robotic machining systems, which is basically more about the control part and the manufacturing and my undergraduate is doing in tjin university, which is also the top university in China mainland and also in mechanical engineering with a GPA 3.72 out of 4. I'm ranking in eighth and my bachelor is doing part of more biomedical engineering parts, which is the design and performance study of ultrasonic scalpel for vertical cutting. And I have published a one paper on in my master, which is done the journal of manufacturing processes and I'm the first author and you can check this Url to access this paper. And this paper is about the reconstruction of surface topography during the, mailing process. And I use the convolutional neural network and other AI techniques to reconstruct the surface during process. 
发言人 1  
Okay, so the first project is is more about engineering parts. And I will go through it quickly because this is not the academic parts. But, but basically is the, the requirement is from a, an, a company and they want to test the robotic muling capability to achieve the online chatter monitoring and suppression the chatter is some kind of self excited vibration. Like without the chatter, the service quality is good and with chatter, service quality is bad and the right panel picture is my platform. We use the ABB industrial robot to do the muling and what I basically do in this project is just set up this robotic milk machining system and I att an accelerometer onto the spindle and I collect some signals like and do the frequency, like fast forward transfer to identify some characteristic frequency and then do some control scheme on the spindle to adjust the speed, spindle speed. The spindle speed is my like executable part because when I adjust the speed of speed, I can eliminate or mitigate the vibration during mule and the suppression chatter suppression mechanism, it's too tedious to expand here. And after all, I encapsulate all the chatter monitoring and suppression into an automated interface and I developed this guioa, this GUI interface in medal app and I can show a very quick video to show this engineering project. Wait? 
发言人 1  
Oh, white. 
发言人 1  
So basically this is. 
发言人 1  
You can hear the noise and little vibration. And I click the button. The noise get eliminated by adjusting spinal speed. 
发言人 1  
Yeah, the noise again. And I click the button, it just automatically compute the optimal spindle speed. Okay? Okay, this is the intuitive effect. So basically, the whole performance consumed 1.6 seconds from detection to suppression, 0.3 seconds for monitoring, 0.3 for decision, and one second for the spindle speed adjustment. Because the spindle speed adjustment is like the blue line, it can not adjust suddenly and has to take take time step by step, like from 5000 Rpm to 707500. 
发言人 1  
Okay, this work produced one paper, but it is still under review to the robotics and computer integrated manufacturing. But it's still under review. Yep, and project 2 is, it's more about academic points. So the thing is we want to quantify the chatter, the self excited vibration during during machining. But in typical way, we usually use our it's like, but we quantify the vibration is to evaluate the surface quality. 
发言人 1  
And usually, typically evaluation on surface quality, you have to use cameras like the structural light or the ultrasonic infrared light cameras. But this lighting system, like they are not that rigid and reliable during terrible manufacturing process. So we change a, we change this mind to instead of using the lighting, we use the accelerometer, we use the sensor to collect this acceleration signal, like during machining these parts and we, and then we use this acceleration signal to reconstruct the surface like this. We collect the accelerators to reconstruct surface and then we use this reconstruct surface to evaluate quality. And then we quantify the vibration. Well, this is, like because because acceleration signal it, you can collect it in real time and it is, rigid during process and it is high frequency contain many information. 
发言人 1  
But the problem is you we are trying to like mapping one dimension mension of time series 2, 200 dimen sional spatial surface information like like analytically, this is not gon na work, this is not gon na work analytically. But, but because of the AI power, because the convolutional neural network, we try this and we also try other architectures like the RN LSTM or other other neural networks. And finally we pick up CNN because it has the ability to extract features automatically and then do this like high dimensionality mapping. And it performs pretty well. And as the result shown on the right panel, the reconstruction quality is good. 
发言人 1  
And to make the whole process more interpretable, instead of mapping from access signals directly to the surface, we actually map to some features parameters like the a cosi phi. So this a cosi phi are the construct reconstruction parameters. So we propose a series of formulas, parametric formulas like some something like the sign let's the sine or cosine functions. And we use these parameters, design sine waves to, superimpose together. Like here we consider the surface can be reconstruct by a series of sine waves. So we, so we output these parameters by the neural network and then we construct analytically using these parameters to get the surface which make the whole network more interpret book. 
发言人 1  
Okay, and after getting this reconstructed surface, we just we propose another's formula to quantify its vibration energy. Like the left panel picture shown, each point represents one pick, one surface. And this surface, we divide it into, like forced vibration and chatter vibration, which is force vibrations, blue chedder vibration energy is orange. And with this quantification, you can identify like which vibration it is suffering the most. And then you can do the strategy and specific strategy to mitigate the specific vibration. And this work is the published on the journal Manufacturing processes. 
发言人 1  
Yes, and that's the brief introduction of my work and my background. Professor Adam, thank you. 
发言人 2  
Yeah, thank you so much. Yeah, I also look at your application. This is impressive. And I have a couple of questions. You worked with math lab, right? For the robotics project, the robotic measuring. 
发言人 1  
Yes, yes, me. 
发言人 2  
Okay, okay, great, so. So, you know, the type of thing that I am thinking, it will probably be with something similar. But my plan is to work a lot on open source software. Not, so have you ever worked on like C++ or . 
发言人 1  
yes, sure CPP and Python? Yes, I actually, I actually work with the Rose 2, but, but I did not include it into my project because, because this is actually the future work of this project. Like, like we actually, like in this project, I rely on the ABB itself control system, but but later we transfer all the system onto ROS 2 because, we integrate the vision camera, the deep vision camera, and we integrate some, I think it's the VL, VLM model and we are trying to make the this robotic machining system have the capability of vision and have the capability of thinking and we as human, we can just tell him with text or natural language and then you can do the machining itself to like like, like schedule the process itself. Yes, but this is not not done yet, so I didn't include it here. 
发言人 2  
Okay? Yeah, no, no, it makes sense. So you know, the first project is really interesting, so it's more of like an instrumentation and engineering, so I have a question about the second project for the CNN like the convolution net, I agree with it's like, you know, really interesting problem. You have to map one dimensional information to two dimensional. So, you know, how did you decide that you'd go with covenant instead of say like LSTM or things like that? Because that is more, you know, come on in terms of time series data. 
发言人 1  
yes, so, so we actually start from the simple neural network, we just? So, so, so first of all, I choose, I test every like common neural networks at first, but for the LSTM, it is more like good at the, you know, like like, sentence, like next word prediction, like output, what's the next word of this sentence instead of capture the, feature of this signal? So basically we, we, so the common sense is we consider this acceleration has abundant information which can be used to reconstruct service, but the problem is if in the past experiences, we will do the feature extraction manually like the, standard variation or other statistics, we would do this manually, but we, want to do it with AI. So the first goal we go with trying to find some neural network which can do the feature extraction automatically for us and this is not the part of LSTM, so we first tried the CNN and also other, I think it's we RN or or other the neural network and we find them good at feature extraction first, yes, and LTM we also test its capability, but it it does not perform that good actually for the results. 
发言人 2  
Okay? And that brings me to my next question, like how's your AI background in general. 
发言人 1  
how sorry AI background. 
发言人 2  
yeah AI background, in terms of like course I looked at your transcript, but I wanted to hear from you like how comfortable you are in terms of, you know, the modern AI stack transformers or things like that. 
发言人 1  
Oh, you mean how confident am I to my AI knowledge like that? I would say right now my, whole working format or working flow I'm trying I am, you know, like, fully integrated to the AI agents or like the clock code or Gemini 3 pro with the anti gravity IDE or this and the problem is, I may not as competitive as other like AI major students, but I think my advantage is I pursue this trend very, tightly, yes, you know, like right now in the like, whether in LM or the AI agent agentic model, they developing very fast like the evolution is is increasingly fast. 
发言人 2  
Yes. 
发言人 1  
fast. Yes, it's incredibly fast. And but, and I am I'm a huge fan of Ao I will like, focus on the YouTube channel and I will, like when it when it propose a new model, I will I'm not just trying it i'm thinking of how can I use this capability to update my working flow or update my project to make make my working flows speed up? Yeah, something like that. Yes, and I would say I'm I maybe a more AI agents application user, yes, but if if you're talking about the ability to develop LM, maybe I'm still lack of this, yes. 
发言人 2  
yeah, that is that's fine because you know, if you do like doctoral studies, that's like the goal that you will probably take courses and that'll give you like enough ideas I'll talk about in very briefly in a few minutes. So I see you have some like doctrin plans, do you want to talk about it? 
发言人 1  
Yes, but I did not include it in this presentation? Yes, but I can, but okay, but I have that in my mind. Yes, because the reason I contact Professor Allu is because I noticed that you are like research on the generative of CAD and autonomous manufacturing process, which is basically is exactly what I, want to, you know, set my career in, yeah, in this fields. Yes, because because AI is like inevitable, inevitable tool in the future, but, but the manufacturing, is too, I would say, not that frontier to employ this AI technology? Yes. 
发言人 2  
because I agree. 
发言人 1  
Yes, so I really wish to, you know, learn or get some innovative insights from from you to how we can deploy AI to this structural industry special manufacturing. 
发言人 2  
Yeah, so that's nice to know. So with that I'll give you like a brief background on the lab and what the plan. So the plan is to work on like intelligent design and manufacturing, as you say, like because of all the AI revolution, I think it is possible to bring all of that into into the AI AI framework. Sorry, the manufacturing framework, because most of manufacturing is not very intelligent. So to do that, I mostly in my Phd, I developed like software and hardware. A lot of my focus was to develop algorithms that can make the process intelligent. And what I saw there are like a lot of gaps in the whole field. And it is possible to make really good contribution that can set you apart from the rest, in the field. 
发言人 2  
So what my lab is trying to do is trying to think about the manufacturing from the design perspective to the manufacturing, the Intel pipeline. 
发言人 2  
When you design something, we need to think about manufacturing, how we want to manufacture it. Is it going to be milling operation? Is there going to be like an additive manufacturing or you know, it like a sheet metal? So you have to think all about that when you design. And also when you go to manufacturing, you need to have like a lot of sensors and take the sensor data, feed the data to like an intelligent control system or like an a brain AI brain for the manufacturing system and do the whole thing. I don't see it realistically entirely autonomous. There'll be humans, obviously, but it will be, you know, much more informed, much more intelligent. So the whole process is very seamless. 
发言人 2  
You can make a lot of things with a lot of, you know, custom parts in a very quick time. Yeah, think. 
发言人 1  
think about like that. Yeah, have you heard, have you heard the company of talent here, have you heard this company before? 
发言人 2  
Yeah. 
发言人 1  
it is doing the industry AI like yeah, that okay? And yeah, sorry, sorry to interrupt, I just mentioned, yeah. 
发言人 2  
and no, no, yeah, it is true, they are like a lot of companies and the challenge for the lab is we will not only compete, be competing with other academic labs, startup companies that are coming out in the us in globally, right? So we don't have money like industry, right? We don't have $80 million sitting around that we can hire employees. It's an academic lab, so we will have to compete intellectually. 
发言人 2  
Do you see what I mean, so it will be a and the whole field is like very demanding right now, it is very interesting and like ton of job opportunities. So it's a very exciting field to be and a lot of people are working on very interesting problems. So that's why my future, plans are and the immediate plan for the lab is to develop like a manufacturing, robotic manufacturing setup, but entirely from the AI perspective, so there will be a very good data collection mechanism and, you know, a lot of sensors and we can take the data and use for, you know, intelligent decision making. So I'm thinking a couple of things. It will probably start with something like additive manufacturing, but we don't want to stop Led manufacturing like, you know, extrusion, robotic extrusion it like that that will be the intro, like the intro to the whole framework when you show that it works, will move to the milling operation and all those things as you know, to see how the progress goes with the project based on that will go with more subtractive manufacturing task and try to make them intelligent. 
发言人 2  
So imagine you have a part if you upload the part in your software AI software, it will immediately know how to plan the processes, which tool to select, which operation to do, how to do the mailing oppress. It will do that digitally in the software. And once that works, then it will execute that in your robotic, physical machine. Yes, that's kind of the goal actually. 
发言人 1  
Actually, I don't want to do this manually If there is an agent can also design or how to choose the tool, how to manage the process, that would be perfect. The agent for the manufacturing process. 
发言人 2  
Yeah, so it will be agency, right? But it will not be entirely autonomous because manufacturing is very hard compared to exactly, you know, making an image or like making a video, making manufacturing is really hard. And so we will develop like prototype systems, okay? And then we'll work with industries to, you know, develop, give them the software and see if it works on their application, okay? The good thing is like Georgia Tech has a lot of special in terms of manufacturing, we have a really good, we call it like a toy factory, we have like an entire factory, but like a miniature version of that. It's like 100000 scarf feet and any manufacturing machine you can imagine, it's probably there like from it's mostly additive, but there's a ton of subtractive too. 
发言人 1  
Perfect, perfect, you mentioned that we will start from additive manufacturing, right? Like the, metal glass, is it metal, so you know. 
发言人 2  
so our main contribution with the software, so we don't want to spend a lot of time on the metal additive because metal additive it, it's very hard to make it work. 
发言人 2  
All the whatever people say, it's kind of very hard to make it work. So we will work on probably polymer based system just to see it works, but with a lot of sensors, like in a lot of cameras to kind of predict all the inaccuracies, all those things. And it will be probably, you know, 5 Xs 3 depending system, not just planner. It should be, you know, so you can print pretty much anything. But we do have a lot of open source editing, toon edit, manufacturing system with Python API. So the next plan would be to use the same algorithm, but with the metal additive manufacturing. And then we'll move from there to subtractive. So I'm not really fixated on the additive manufacturing side, if that makes sense. 
发言人 1  
Okay, understood. Yes. 
发言人 2  
because most of the value comes from subtractive In industries like 80% of manufacturing process, it's subtracted, right, milling operation and all those things. So, there will be the goal. We will, probably work with a lot of manufacturing experts to, but a lot of the focus of the lab will be to develop AI algorithms itself. We can not just use, you know, Jim and I or Claude or ChatGPT, so we will have to develop our own model, probably we will train small foundation models like visual language models and integrate all the sensor data with that sort of like what you are talking about. Some of your future projects, it would be, you know, something similar to that. You will develop algorithms and include sensor data and try to combine them in very intelligent way to make really good decisions that's kind of the plan of the lab. 
发言人 1  
Okay, understand, yeah, thank you, thank you so much. Yeah, okay. 
发言人 2  
right, so with that, do you have any question about the lab working with like a new Pi or Georgia Tech in general? Then I'll talk about a couple of logistics after that. Any question? You can you can you? 
发言人 1  
Yes, so basically like. Because I I'm really interested in your research, that's why I contact you directly. And I already submitted my application to Georgia Tech. Yes, like what's the possibility of my proposal to join your lab? Do you have like. 
发言人 2  
yeah. 
发言人 1  
or I mean, is it is it depends on on you or it depends on the comedy of Georgia Tech? 
发言人 2  
I think that's a better question, you know, because, so I don't, have the to, you know, directly hi students, so the student has to get admitted into through the Georgia system, right? So they have like a central committee, they will take the decision and they have a pool of students then they will let me know that. And all the faculties that, you know, we have pool of his students. You may want to contact them and see who overlaps. 
发言人 1  
Okay. 
发言人 2  
so I been having said that, you know, but I do have the opportunity to intervene before making a decision, so probably not now, it will probably be sometime in January, right? Because the holidays are coming. So they will be making a decision in January. And, you know, probably at that time I'll be able to, you know, provide more insight. 
发言人 1  
okay? Okay, understood. Another question is. As we mentioned, our, if we are doing the AI for manufacturing part, it is like maybe, would it consider as more academic or more entrepreneur, project like develop our own AI algorithm or agent? 
发言人 2  
Yeah, that's, yeah, that's a good question. I like how you were thinking about this, it should be very new, right? So the only other people I know, who are doing something similar in terms of energy manufacturing is a group, in England. So all of them become like a company eventually. So because it's very new idea, so if we can't do a good job, it will be beyond, you know, academic work, obviously, so everything will be proprietary, the software architecture, what you do, and also the not the hardware, the hardware will be, you know, it will be simple robotic platforms, but the main intellectual contribution will be the inter framework or the software, the AI algorithm, and the integration of all those things into one place you can think of like, you know, I give this example to everyone like think of like, Apple if you have you ever used Apple devices. 
发言人 1  
sure, iPhone, ipad mac. 
发言人 2  
exactly, so what's like the best thing about all those things is so one integrated software . 
发言人 1  
is like one ecosystem, Yes. 
发言人 2  
exactly, so whenever you are kind of like an ipad or an iPhone or an even a MacBook or MacBook, it doesn't matter, you can use like Airdrop, all those really cool things which in none other operating system do so what we are trying to do is technically be like an operating system for manufacturing, okay? That's kind of the goal so and you know the students that I'm interviewing, I really need to know like would you be comfortable in terms of taking like fundamental AI classes or, you know, advanced AI classes? It will be a lot of technically demanding coursework just to, you know, upgrade your knowledge of instead of the art AI. 
发言人 1  
but that's, that's totally fine for me. Yes I've learned like I've self-start many AI knowledge to me, yeah I'm a huge fan of, yeah, because this is the trend, this is the future, you have to embrace the future, no? 
发言人 2  
Yeah, I believe so too. So okay with that, if you have another question, then very quickly a couple of logistics, as I said, I will not make the decision on admission, so that's part of like, you know, the central committee, Georgia Tech. 
发言人 1  
okay, so I understand. 
发言人 2  
Yeah, so once if you hear anything from the committee in January, do let me know or you already submitted your application. So yeah, and from my end, if I have any update, I already know I'm also interviewing, you know, other students too and probably by January before the end of January, I will make a decision and you know, let you know. 
发言人 1  
like midterm or the end January. 
发言人 2  
I don't know, so it depends on, you know, the admission committee too. So, and I'm hiring actually multiple students. So there'll be I think there'll be like 1 or two students working on the robotic project and all three students working on the AI and design project, so they will complement each other. So I was thinking more you more of for the robotic robotic part AI and robotics, yeah, so. Depending on that and how many students we can work with. So, you know, I have to work with like I'm guessing 3, 3 to 40 students. So wow, that's good. And yeah, I have to interview a lot of people, so I'll probably get back to you in January. 
发言人 1  
okay? 
发言人 2  
Okay, but if you will hear anything from the admission committee, keep me in the loop. Even if you don't get like an official decision, like, you know, a wait list or something like that, do let me know. Keep me updated. 
发言人 1  
Okay, thank you, yes, I will, I will. 
发言人 2  
That will, yeah, that's pretty much it, and yes. Yeah, it was nice. And thank you for your time. We'll see how it goes. Okay. 
发言人 1  
okay, bye bye, bye bye. Yeah. 
发言人 2  
thank bye bye, take care. 