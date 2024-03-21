BIOM/ECE431
Instructor: Dr. Jesse Wilson
Colorado State University
Walter Scott Jr. College of Engineering


#Neural Network Models for Electrocardiogram Classification
Feasibility Proposal
Austin Bostwick, Nicholas Emer, Jack Lattanzi, Nate Peebles, and Ty Thourot
February 6, 2024
Colorado State University, Fort Collins, CO 80521





Team Roster:
Austin Bostwick - Team Lead
I am a senior studying Electrical Engineering with an expected graduation date of December 2024. For my senior design project, I am on a team developing a handheld infection and disease detection device using electrochemical sensors and electro-wetting on a dielectric (EWOD). I am interested in pursuing the biomedical industry when I graduate. My strengths include extensive programming experience, data analysis, and my ability to both lead and work in a team. 
	My job is to organize and submit documentation relating to this project. This also includes ensuring that the project is going smoothly and that the project will be finished within the deadline. I will also be leading the front for the neural network classifications because I have more knowledge regarding that subject. 

Nate Peebles - Lead Biomedical Data Analyst, Technical Lead
My name is Nate Peebles, I’m a 4th year BME + EE student. I am extremely interested in biosensors and the electrical circuits behind them. My strengths are project and team management. I'm a former co-lead of the biomed sub team for the ECE Outreach group and the current electrical team lead for the BMES Case Study Project as well as one of the executives on the project. In my position, I am responsible for developing project plans and timelines, selecting components, delegating tasks to team members, and overseeing the implementation and testing of our designs.

Nick Emer - Software Development Lead
	I’m Nick Emer, a 4th-year BME + EE student. I have worked on projects in the signal processing space in adaptive filtering and have also done significant work using electromyography in conjunction with an arduino. Through both of these I have gained good experience working with signals and specifically using different filtering techniques to remove noise. My strengths lie in my experience with my interdisciplinary knowledge with biomedical and electrical engineering as I have done expansive work applying electrical engineering tehcniques to biology. I am also very experienced in project management through both projects in coursework as well as in a professional capcity in internships. My role in this project is mainly focusin on the Neural Network research and development, in the feasibility role this will mostly be research and verification and then will be more on the development side of actually creating the model. 

Jack Lattanzi - Research & Development Lead 
	I am a senior studying Electrical Engineering with an expected graduation date of December 2024. I also have a minor degree in biomedical engineering, and my senior project is focused on MRI research. I have worked on projects dealing with ECG signals before and have some experience working with this data and filtering signals. I have skills in programming for biomedical applications as well as working on digital systems from courses at CSU and internships.  Biomedical image and signal processing are of my highest interest as this is the field I wish to work in after graduation. I am interested in learning about neural networks for these applications as deep learning will likely be used to aid doctors in medical diagnosis in the future. I am looking to contribute to the role of organizing the research and development on this team. Where I will lead others in finding information, databases, and code examples to help the project progress. I will also focus on helping with the development and training of the neural network and the characterization tool for this project. 

Ty Thourot -  Systems Engineering Lead
My name is Ty Thourot and my strengths are systems engineering. I am able to put multiple separate systems together in a workable way. My interests are human spaceflight, which does include the biomedical side of things. These types of scans and signal processing are very important when in space, as the lack of gravity can and will affect the human body. My role in this team is to connect all the research and data into one usable piece.

Roles:
Each person will be in charge of a specific role depending on the progression of the project. This person will not be alone in this role, they will simply guide the others in what they need for support to complete the task they are working towards. 

Nate -  Neural network research and design
Nick - Neural network research and design
Jack - Taking in/ classifying data 
Austin - Taking in/classifying data (Team Lead)
Ty - Overseeing the connection and integration of the two main parts of the project

End of Semester Goal
	By the end of the semester, our group hopes to create a neural network that is able to distinguish between a normal heart rate and ventricular arrhythmia/fibrillation and atrial fibrillation. We hope to create a convolutional neural network to classify each of these irregularities. Convolutional neural networks are great at anomaly detection, and they take fewer learning parameters than a fully linked neural network. This program will use publicly available data sets to train the weights and learning parameters. 
	This program would allow clinicians to take a patient's heart rate signal and receive a complex analysis of the data. Would not be worth a clinician’s time to look at the hours of patients' data. So, for a program to do a complex analysis of the data in minutes. It would help diagnose the patient early to prevent death or health-related issues. 
Goal for the Feasibility Phase
	By mid-March, we aim to have a clearer picture of how feasible our end-of-semester goal is, particularly in terms of understanding cardiac arrhythmias and fibrillations and our application of Neural Networks. It is important that we first conceptually understand the abnormalities we are trying to classify and additionally, gain a thorough understanding of neural networks so that, by the end of the feasibility phase, we have a well-defined map to be able to complete our end-of-semester goal.
We plan to look closely at the various abnormalities that can affect the PQRS-T curve in different ways. It's important to identify and categorize these patterns accurately because they're key to diagnosing the range of arrhythmias. Since each type of arrhythmia might need a different treatment, getting the classification right is critical. By that time, we also hope to have a good grasp of the different types of arrhythmias and their specific characteristics. This detailed understanding will help us make sure our convolutional neural network is on the right track. We're looking for a proof of concept from the network that will give us confidence in our ability to meet our goal by the end of the semester.
In terms of program development, we are looking to research preexisting Neural Network models to decide what technique to use moving forward. There are many different options we have already begun to research including, convolutional (CNN), recurrent (RNN), long term short memory (LTSM), and more. So, during the feasibility stage we will be doing more research on the different options and making a decision on which technique to use moving forward. For this, we will use some proven examples of models that have already been developed to and then build off of them based on our specific applications. Furthermore, many of these developed models have been created with the application of classifying either atrial-fibrillation or normal signals. Our end goal is to be able to classify other abnormalities on top of this. Thus, it would be advantageous to have built out to the extent of these proven examples by the end of the feasibility stage so that we have adequate time to go beyond the capability these models. At this point, if we have immense difficulty in implementing a model that classifies a set of atrial-fibrillation and normal signals we will have to reevaluate our end-of-semester goal and be willing to pivot to our backup plan.



Back-Up Plan:
If you discover your plan was too ambitious, or in principle impossible, or cannot get access to the data or tools you need, what options will you pursue instead?
In the unfortunate situation of the team unable to reach our main goals of implementing Neural Networks to the fullest extent, we will pursue our backup plan of taking apart an open-source neural network to understand the internal functions. This will help us discover how to create our own Neural Network if we had more time. 
Based on the available resources, I now think that regardless we should at least be able to develop a neural network model. I would say our backup plan would be to limit its classification to a few simple abnormalities instead of the multiple we have above in the end-of-semester goal. 
Take apart an open source neural network and understand the internal functions and how we would create one with more time
Still have functioning program capable of classifying Ventricular Arrhythmia and Ventricular fibrillation compared to healthy ECG signal, just without the use of Neural Network
Simple classification code that subtracts two signals and determines if they are inside a tolerance that would be considered a non-normal signal


Collaboration Plan:
The team will use Google Drive and Github to handle all the documents and the code. The shared Google Drive folder will house all the team documents. These documents include the project proposal and edited versions created from peer review with updates as the project progresses. The drive will also have links to all the datasets, Github, and code versions. There will also be neural network resources, examples, and other ideas for the code. The model in progress will be created and updated in GibHub to allow the different versions to be worked on and new functions to be integrated as the project progresses. 
The team will meet once a week over Microsoft Teams to plan the specific week's goals and deliverables. Here, leaders for each task will be assigned, and they will decide what they need help with to complete the specific task. The team will also decide on additional meetings to complete these tasks on time. These additional meetings will be in place to allow time to work on the code and the model for the network. We will track who is responsible for completing each weekly task through a listed work breakdown Google sheet. Conflicts and disagreements will be handled individually. If it cannot be handled between the two individuals, the team will discuss it in a calm environment. The team will make sure to make each person’s voice welcome by fostering a culture of patience and inclusion and ensuring each person has the opportunity to contribute to the extent they desire. If a team member is underperforming, they will be addressed by the team and asked to contribute more. If this issue persists, the team will take the problem to Dr. Wilson.

Potential databases to use in characterization and training:
https://physionet.org/content/cudb/ - valuable ventricular tachycardia data
https://physionet.org/content/ecg-arrhythmia/ - 12 lead ECG arrhythmia study, 10,000 patients
https://physionet.org/content/mvtdb/ - spontaneous tachyarrhythmia database in 78 subjects. https://physionet.org/content/vfdb/  -  This database includes 22 half-hour ECG recordings of subjects who experienced episodes of sustained ventricular tachycardia, ventricular flutter, and ventricular fibrillation.

Possible Plan of helpful resources to use:
Framework to use:
 TensorFlow- to learn how to create the network aid in training. 
Keras (Part of TensorFlow) will also be useful for the team as we are all beginners in this area.
Python will be used for all the code. 
Model Architecture: feedforward neural network with 1-3 hidden layers
Activation functions: Sigmoid for outputs / ReLU for inputs
Optmizer: Adam
Tutorials and documentation: TensorFlow/Keras
Finding a relevant model: GitHub
Potential Plan of Action (GitHub Route):
Find Github Repository
Understand the existing code
Adapt the Code for ECG data
Experiment to advance the code
Potential Plan of Action (TensorFlow + Github)
Learn TensorFlow fundamentals
Setup Development environment
Practice with simple models and save progress in Github
Dive into deeper/ more advanced models
Use large ECG database to experiment and train


