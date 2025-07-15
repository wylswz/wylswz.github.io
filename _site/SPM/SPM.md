# SPM
## Process
### PMP
* Formal
    * SDLC
        * Waterfall
         * > Adv
         * > Simple
         * > Easy to manage
         * > Phase one at a time
         * > Doc
         * > Work well when req clear
         * > Disadv
         * > Change
         * > One phase must be finished to move on
         * > Unclear req -> confuse
         * > Client approval at final stage
         * > Difficult to integrate risk man

        * V
        * Incremental
         * > Adv
         * > Each release delivers an operational prod
         * > Less costly to change
         * > Customers respond to each build
         * > Init delivery fast
         * > Customers get important func early
         * > Easier to debug
         * > Disadv
         * > More resources
         * > More management attention
         * > Hard to define increment
         * > Each phase of an iteration is rigid
         * > Problems occur at integration

    * Exclusive Summary
    * Stakeholders
    * Scope
    * Resources
    * Milestones
    * Budget
    * Business Value
    * Lesson learned
    * Constraints
    * Roles & Responsibilities
    * Key activities
        * Scheduling
         * > One of the important artefacts generated during the project planning phase
         * > Is used and maintained throughout the project to monitor and track project progress
         * > 
         * > Contains:
         * > Tasks
         * > Duration
         * > People
         * > Milestones and deliverables
         * > Timeline

            * WBS
            * Interdependencies
            * Estimate effort
            * Allocate Resource
            * Develop project schedule
        * EVA
            * Planned Value
             * > The portion of the approved cost estimate planned to be spent on the given activity during a given period

            * Earned Value
             * > The value of the work actually completed

            * Actual Cost
             * > The total of the costs incurred in accomplishing work on the activity in a given period

            * Schedule Variance
             * > SV = EV - PV

            * Schedule Performance Index
             * > EV/PV

        * Risk Management
         * > An uncertain event or condition that, if occurs, has a positive or negative effect on the project objectives.

            * Categories
                * Business risks
                * Project risks
                * Product risks
            * Process
                * Plan
                    * Output: RMP
                        * Methodology
                        * Roles and Responsibilities
                        * Budget and Schedule
                        * Risk Categories
                        * Probability and Impact
                        * Tracking
                        * Risk Documentation
                        * Contingency Plans
                        * Fall-back Plans
                * Identify
                    * Pondering
                     * > This simply involves an individual taking the pencil and paper approach of risk identification. Sitting and thinking about possible risks
                     * > One of the init risk assessment tasks used in many projects

                    * Interviewing
                     * > Interview stake holders, questionnaires.

                    * Brainstorming
                     * > Use a risk framework or work breakdown structure to identify.
                     * > Encourage contributions from everybody
                     * > The group then diss and evaluate.

                    * Checklists
                     * > Use of standard checklist of possible risk drivers that are collected from experience
                     * > Checklists are used as triggers for experts to think about the possible types of risks in this area

                    * Delphi TEchnique
                     * > A group of experts are asked to identify risks and their impacts
                     * > The response and them made available to each other anonymously
                     * > The experts then are asked to update their response based on the responses of others. Repeat until consensus is reached

                    * SWOT
                * Assess
                    * Probability
                     * > Usually based on expert judgement

                    * Impact
                     * > Impact
                     * > 1 - 5 or 10
                     * > Can be expressed as a monitory value

                * Respond
                    * Accept or ignore
                     * > We believe that the risk is of an acceptable exposure, that we hope that the event does not occur, or that the risk exposure is less than that cost of any techniques to avoid, mitigate or transfer it

                    * Avoid
                     * > Completely prevent from occurring

                    * Mitigate
                     * > Involves employing techniques to reduce the probability of the risk or reduce the impact. Results in a residual risk, that is the risk consisting of the same event but lower probability impact.

                    * Transfer
                     * > Transferring the burden of the risk to another party. 
                     * > 
                     * > Insurance or outsourcing

                * Monitor and control
        * Cost Estimation
            * Factors
                * Effort
                * Hardware
                * Travel
                * Training
                * Communication
            * Software size estimation
                * Source Lines of Code
                    * Physical
                    * Logical
                * Function Points
                 * > Measure size of solution instead if problem
                 * > Req are the only thing needed
                 * > Can be done early
                 * > Independent of tech
                 * > Independent of lang
                 * > Disadv:
                 * > 	Well defined spec is necessary
                 * > Gaining proficiency is not easy
                 * > Costly

                    * Categorize req
                        * Internal Logic File (ILF)
                        * Exter Interface File (EIF)
                        * External Input (EI)
                        * External Output (EO)
                        * External Query (EQ)
                    * Estimate complexity for each category
                        * Data Element Types (DETs)
                         * > A unique, user-recognizable, non-repeated data filed in a system

                        * Record Element Types (RETs)
                         * > A user-recognizable subgroup of data element in an ILF or EIF

                        * File Type References (FTRs)
                         * > A file (ILF EIF) referenced by a transaction

                    * Compute COUNT TOTAL from complexity 
                     * > Weighted sum of categories and their weights corresponding to the complexity

                    * Estimate value adjustment factor
                     * > Summing 14 factors, each from 0 to 5

                    * Compute total function point count
                     * > Count Total * (0.65 + 0.01 * Adjustment Factor)

                * Use-case Points
                    * Compute Unadjusted Use Case Weight
                    * Compute Unadjusted Actor Weight
                    * Compute Technical Complexity Factor
                    * Compute Environmental Complexity Factor
                    * Compute the final size estimate
        * Quality Assurance
        * Configure Management
        * Communication Management
        * Release Planning
            * Scope fixed
            * Budget fixed
            * Schedule fixed
    * Summary: Project information
    * Summary: project Governance
* Agile
* > Iterative dev
* > self-organizing
* > Cross-functional team
* > Encourage teamwork
* > Frequent inspection and adaption
* > Rapid delivery of high-quality software
* > Align dev with customer needs and company goals
* > Adv
* > Rapid
* > Interaction
* > Continuous attention
* > Change welcome
* > Disadv
* > Hard to assess effort at beginning
* > Demanding on users time
* > Hard for new starter to integrate into team
* > Intense
* > Experienced resources

    * Frameworks
        * Scrum
         * > Self-organizing teams
         * > Sprints
         * > Product backlog
         * > Time frame of weeks or months

            * Roles
                * Product Owner
                 * > Defines
                 * > Release date and content
                 * > ROI
                 * > Priorities features according to market values
                 * > Adjust features and priority every iterations
                 * > Accept/Reject work results

                * Scrum Manager
                 * > Represents management to the project
                 * > Enacting Scrum values and practices
                 * > Removes road blocks
                 * > Ensure team is fully functional
                 * > Enable close coop
                 * > Shield team
                 * > Member of team

                * Team
            * Ceremonies
                * Sprint planning
                 * > HOW to reach goals
                 * > Create SPRINT BACKLOG
                 * > Estimate velocity and Story points
                 * > Priority guide
                 * > Release plan created
                 * > High level design

                * Sprint Review
                 * > What's done during sprint
                 * > Demo
                 * > Informal
                 * > 2 h
                 * > No slides
                 * > Whole team

                * Respective
                 * > What's / isn't working
                 * > 30 min
                 * > Done after every sprint
                 * > Master and team (others probably)
                 * > What to start, stop contd

                * Daily Stand-ups
                 * > Daily
                 * > 15 min
                 * > Stand up
                 * > Team members, master, owner talk
                 * > Help avoid unnecessary meetings
                 * > What did I do
                 * > What will I do
                 * > How?

            * Artifacts
                * Product Backlog
                    * User stories
                * Sprint Backlog
                * Burndown charts
        * Kanban
    * Management
        * Estimation
            * User stories
            * Estimate story points
            * Use velocity to estimate delivery time
            * Measure actual velocity
            * Estimate again
## Leadership
> Leadership is the ability to influence and direct people to achieve a common goal
> Management is the process where resources are used and decisions made in order to achieve the goal
> Leaders inspire and motivate people to meet the goal
> Managers set objectives and decide how to achieve
> PM is both Leader and Manager

### Lead & Manage
* Power
* influence
### Team
> Two or more individuals consciously working together to achieve a common objective
> 
> Why:
> Enhanced opportunities
> Greater productivity
> Increased ownership
> Creativity/Innovation
> Greater joy and satisfaction
> Broader perspective
> Increased representation
> Increased equality
> More dialogue
> Disadv
> Take time to manage
> Some individuals find it difficult
> Unequal involvement
> One person can demoralize the whole team
> Social loafing
> Group think

* Lifecycle
    * Forming
     * > Establish ground rules and preserving formalities

    * Storming
     * > Members communicate but maintain strict individuality

    * Norming
     * > Team bonding and higher acceptance

    * Performing
     * > Less emphasis on hierarchy and more flexibility

    * Adjourning
     * > Yearly assessment and plan for acknowledging contributions

* Effectiveness
* Structure
    * Controlled Centralised
     * > Leader coordinates tasks and direct work
     * > Communication and control are vertical
     * > Sub-teams with leaders to direct and guide sub-groups

    * Controlled Decentralised
     * > Leader coordinates tasks
     * > Sub-teams with leaders
     * > Communication horizontal, control is vertical
     * > Problem solving is a team task

    * Democratic Decentralised
     * > No permanent leader
     * > A coordinator is appointed for short durations
     * > Communication and control are horizontal

    * SWAT
     * > No permanent leader
     * > A highly specialized team
     * > Put together for a particular task

    * Scrum Team
### Group
> A collection of people working together who do not necessarily work collectively toward the same goal

### Individual
## Management Team
### Proj man
### Quality man
## Swat Team
### Req
### Design high
### Design detailed
### Implementation
### Test
## The team
### Proj management
### Req specification
### Design
### Implementation
### Test
## PM
### Req engineering
* Req specification
### Designers
* High level design
* Detailed design
### Programmer
* Implementation
* Test
### Proj man
### Quality man
## Floating Topic
### Conf Man
### Req man
### Tech leader
* Tester
* Arch
* Prog
* GUI

*XMind: ZEN - Trial Version*