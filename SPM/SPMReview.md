# Software Process and management

## L1

### Process
- A process is a series of progressive and interdependent steps by which an end is attained
- Project management is a process as it defines a series of tasks
- SDLC describes a process for planning, creating, testing and deploying an information system.

### PMP
Almost every org has its own version of PMP.

a **PMP** is a formal approved doc that defines how the proj is executed， monitored and controlled. It is a detailed doc to **establish** and **manage** the project.

A **Project Charter** is a summary project proposal to secure approval for the project goals and terms. (Summary of key information used to **communicate**, engage, **gain buy-in**, and obtain **approvals**)

PMP categories:
- Porject Information
    - Executive summary
    - Financial authority to proceed
    - Key stakeholders
    - Scope
    - SDLC
    - Resources/People
    - Milestones
    - Budget
    - Business value
    - Lesson learned
    - Contraints
- Project Governance
    - Roles/Responsibilities
    - Mandatory project planning/Key additional activities:
        - Schedule
        - Risk management
        - Cost estimation
        - Quality assurance
        - Configure management
### SDLC
Process:
- Requirements gathering 
- System design
- Implementation
- Integration
- Testing
- Delivery and Release (Deployment)
- Maintenance

Formal models:

- **Waterfall**
    - advs:
        - Simple, easy to understand
        - Easy to manage
        - Phases are processed and completed one at a time
        - Doc available
        - Works well if req well understood
    - disadv:
        - Difficult to accommodate change
        - One phase must be finished before another one
        - Unclear req leads to confusion
        - Client approval at finish stage
        - Difficult to integrate risk management due to uncertainty
  
- **Increment Model**:
  The whole requirement is divided into various releases. Multiple cycles take place, making the life cycle a multi-waterfall cycle. Cycles are divided up into a smaller, more easily managed modules.

    - Advs:
        - Each release delivers an operational product
        - Less costly to change the scope/requirements
        - Customers can respond to each build
        - Initial product deliver is faster
        - Customers get important functionality early
        - Easier to test and debug during smaller iterations

    - Disadv:
        - More resources may be required
        - More management attention is required
        - Defining / partitioning the increments is difficult and often not clear
        - Each phase of an iteration is rigid with no overlaps
        - Problems may occur at the time of final integration

- **V_Model**:
  V Model is an extension of waterfall model and is based on the association of a testing phase for each corresponding development stage. This is a highly-disciplined model and the next phase starts only after completion of the previous phase.

    - Advs:
        - Simple and easy to understand and use
        - Each phase has specific deliverables and well defined objs and goals
        - High Chance of success over waterfall due to development of test plans early on during life cycle
        - Works well for small projects when requirements are easily understood
    - Disadvs:
        - Very rigid process like waterfall model
        - Little flexibility and adjusting scope is difficult and expensive
        - Software developed during implementation phase, no early prototypes
        - No clear path for problems found during testing
        - Changes in later stage cause test documentation across all stages to be changed


