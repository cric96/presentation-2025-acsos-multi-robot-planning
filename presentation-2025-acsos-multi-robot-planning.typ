#import "@preview/touying:0.6.1": *
#import themes.metropolis: *
#import "@preview/fontawesome:0.5.0": *
#import "@preview/ctheorems:1.1.3": *
#import "@preview/numbly:0.1.0": numbly
#import "utils.typ": *

// Pdfpc configuration
// typst query --root . ./example.typ --field value --one "<pdfpc-file>" > ./example.pdfpc
#let pdfpc-config = pdfpc.config(
    duration-minutes: 30,
    start-time: datetime(hour: 14, minute: 10, second: 0),
    end-time: datetime(hour: 14, minute: 40, second: 0),
    last-minutes: 5,
    note-font-size: 12,
    disable-markdown: false,
    default-transition: (
      type: "push",
      duration-seconds: 2,
      angle: ltr,
      alignment: "vertical",
      direction: "inward",
    ),
  )


// Theorems configuration by ctheorems
#show: thmrules.with(qed-symbol: $square$)
#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eeffee"))
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong
)

#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Example").with(numbering: none)
#let proof = thmproof("proof", "Proof")

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  config-common(
    // handout: true,
    preamble: pdfpc-config,
    show-bibliography-as-footnote: bibliography(title: none, "bibliography.bib"),
  ),
  config-info(
    title: [A Field-based Approach for Runtime Replanning in
Swarm Robotics Missions],
    subtitle: [],
    author: author_list(
      (
      (first_author("Gianluca Aguzzi"), "gianluca.aguzzi@unibo.it"),
      (("Martina Baiardi"), "m.baiardi@unibo.it"),
      (("Angela Cortecchia"), "angela.cortecchia@unibo.it"),
      (("Branko Miloradovic"), "branko.miloradovic@mdu.se"),
      (("Alessandro Papadopoulos"), "alessandro.papadopoulos@mdu.se"),
      (("Danilo Pianini"), "danilo.pianini@unibo.it"),
      (("Mirko Viroli"), "mirko.viroli@unibo.it"),
      ),
      // affiliations: (
      // ("1", "Department of Computer Science and Engineering, University of Bologna, Cesena, Italy"),
      // ("2", "Department of Electrical and Computer Engineering, Mälardalen University, Mälardalen, Sweden"),
      // ),
      logo: "images/complete-logo.svg",
    ),
    // date: datetime(day: 30, month: 09, year: 2025).display("[day] [month repr:long] [year]"),
    // institution: [University of Bologna],
    // logo: align(right)[#image("images/disi.svg", width: 55%)],
  ),
)

#set text(font: "Fira Math", weight: "light", size: 18pt)
#show math.equation: set text(font: "Fira Math")

#set raw(tab-size: 4)
// #show raw: set text(size: 0.85em)
#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: (x: 1em, y: 1em),
  radius: 0.7em,
  width: 100%,
)
#show raw.where(block: true): set text(size: 0.75em)

#show bibliography: set text(size: 0.75em)
#show footnote.entry: set text(size: 0.75em)

#set list(marker: box(height: 0.65em, align(horizon, text(size: 2em)[#sym.dot])))

#let emph(content) = text(weight: "bold", style: "italic", content)
#show link: set text(hyphenate: true)

// #set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

// == Outline <touying:hidden>

// #components.adaptive-columns(outline(title: none, indent: 1em))

= Introduction


== Reference Scenario - Search and rescue mission in disaster zone
// Picture 40 autonomous robots in a disaster zone -- Figure

#let referenceScenario = box[
  #table(inset: 0.1em, stroke: none, columns: (0.7fr, 1fr), align: (left, left),
    [
      #figure(
        image("images/recovery-area.jpg", width: 100%),
      ) 
    ], [
      - Robots move autonomously to check damaged buildings
      - They may already know some information about the area (e.g., where the buildings are located)
      - Communications: spotty, unreliable, low-bandwidth
      - Robots may fail: battery, sensors, actuators
      - Mission goal: check as many buildings as possible in a limited time
      - How to coordinate the robots?
    ]
  )
]

#referenceScenario


== Central Problem

#let centralProblem = box[
  #table(inset: 0.1em, stroke: none, columns: (1fr, 0.7fr), align: (left),
    [
      - Planning: create a plan where each robot has a sequence of buildings to visit
      - Initial plan created before the mission starts
      - Based on known information about the area
    - Re-planning: update the plan during the mission
      - New information about the area (e.g., new buildings, obstacles)
      - Robot failures
    - Dilemma:
      - When should the robots decide "we need a new plan"
      - What information should be considered to create the new plan?
    ],[
      #figure(
        image("images/warehouse-1.jpg", width: 105%),
      ) 
    ]
  )
]

#centralProblem

== Background
- Traditional approaches
  - Centralized planning: a central entity creates and updates the plan
    - Pros: can consider global information
    - Cons: single point of failure, communication overhead
  - Fully distributed planning: each robot creates and updates its own plan (based on local information)
    - Pros: no single point of failure, scalable
    - Cons: may not consider global information, coordination challenges
- Idea: using both local and global information to create a more robust and efficient planning approach
- This is where our field-based approach comes in
  - When create a global "field" that represents the environment and the robots' state
  - Robots use those field to understand when to replan and how to coordinate

== Field-based Approach - Overview
- Write the usual intro on AC

#figure(
  image("images/acDevices.svg", width: 80%),
)

= Contribution
== Field-based Replanning 
- *Detection:* When should we rebuild our understanding?
- *Construction:* How do we build a consistent view together?
- Aggregate is used to create a global field
  - Each robot contributes its local information to the field
  - The field is updated periodically
- Robots then should understand when to replan based on the field
  - If the field indicates that many buildings are unvisited, robots may decide to replan
  - If the field indicates that many robots have failed, robots may decide to replan


== Field-based Replanning - Gossip-based

== Field-based Replanning - Leader-based

= Evaluation

#let snapshots = box[
  #figure(
    table(inset: (0.3em, 0.5em), stroke: none, columns: (1fr, 1fr, 1fr, 1fr), align: (center, center),
    [
      #figure(
        image("images/snapshot-1.png", width: 100%,)
      )
    ],[
      #figure(
        image("images/snapshot-2.png", width: 100%,)
      )
    ],[
      #figure(
        image("images/snapshot-3.png", width: 100%,)
      )
    ],[
      #figure(
        image("images/snapshot-4.png", width: 100%,)
      )
    ],
    ),
    // caption: text(size: 13pt)[
    //   Experiment snapshots with 20 robots (little pink dots) and 80 tasks (red dots, which turns green when completed).
    //   Pink lines are the robot trajectories, gray squares are inactive or failed robots.
    //   Gray lines are the communication links.
    // ]
  )
]


== Simulation Setup

- Environment: 200x200m square area
- Robots: 5, 10, 20, 40 robots
- Tasks: 0.5x, 1x, 2x, 4x robot count
- Communication range: 20m, 50m, 100m, unlimited
- Robot failures: Poisson process (mean time: 1000s to 50000s)
- Speed: 0.5 m/s constant
- Task completion: stay within 10cm for 60s
- 32 random seeds for statistical validity

== Baseline Approaches

- Oracle-based Centralized Replanning:
  - Perfect real-time view of entire system
  - Immediate recomputation upon any failure
  - Represents ideal upper bound performance
- Late-Stage Replanning:
  - Execute initial plan without adaptation
  - Only replan when robot finishes all assigned tasks
  - Minimizes overhead but inefficient for failures

== Metrics

- Mission Stable Time (T_s): elapsed time until all possible tasks completed
  - Lower values = better performance
  - Proxy for mission efficiency despite disruptions
- Replanning Count (C): average replanning events per robot
  - Quantifies computational overhead
  - Measures responsiveness to changing conditions

== Key Results - Communication Range Impact

#snapshots

- Sufficient communication range is critical for both approaches
- With good connectivity (≥50m): near-optimal performance
  - Both approaches achieve performance comparable to Oracle
- With poor connectivity (20m): substantial degradation
  - Network segmentation → wrong failure assumptions
  - Inconsistent system views → tasks assigned to multiple robots
- Fundamental requirement: adequate connectivity for field-based coordination


#let replanningCount = box[
  #figure(
    table(inset: (0.1em, 0.1em), stroke: none, columns: (1fr, 1fr), align: (center, center),
    [
      #figure(
        image("images/replanning_count_20nodes_taskfact1.png", width: 80%,)
      )
    ],[
      #figure(
        image("images/replanning_count_20nodes_taskfact2.png", width: 80%,)
      )
    ],[
      #figure(
        image("images/replanning_count_40nodes_taskfact1.png", width: 80%,)
      )
    ],[
      #figure(
        image("images/replanning_count_40nodes_taskfact4.png", width: 80%,)
      )
    ],
    ),
    // caption: text(size: 13pt)[
    //   #figure(
    //     image("images/replanning_count_legend.png", width: 60%,)
    //   )
    // ]
  )
]

== Key Results - Resilience to Failures

#replanningCount

#figure(
        image("images/replanning_count_legend.png", width: 35%,)
      )

- Gossip-based approach: significantly more resilient
  - Consistent performance even with high failure rates (λ⁻¹ = 1000s)
  - Scales reasonably with increasing nodes and tasks
- Leader-based approach: vulnerable to frequent failures
  - Good performance until failure rates increase
  - Coordination gaps during leader failure and re-election
- Both approaches deliver comparable performance at low failure rates

#let isDoneGossip = box[
  #figure(
    table(inset: (0.3em, 0.1em), stroke: none, columns: (1fr, 1fr), align: (center, center),
    [
      #figure(
        image("images/isDone_gossip_20nodes_taskfact1.png", width: 80%,)
      )
    ],[
      #figure(
        image("images/isDone_gossip_20nodes_taskfact2.png", width: 80%,)
      )
    ],[
      #figure(
        image("images/isDone_gossip_40nodes_taskfact1.png", width: 80%,)
      )
    ],[
      #figure(
        image("images/isDone_gossip_40nodes_taskfact4.png", width: 80%,)
      )
    ],
    ),
    // caption: text(size: 13pt)[
    //   #figure(
    //     image("images/replanning_count_legend.png", width: 60%,)
    //   )
    // ]
  )
]

== Key Results - Scalability

#isDoneGossip

#figure(
  image("images/isDone_legend.png", width: 35%,)
)


- Increasing robots/tasks increases completion time (expected)
- Both field-based methods scale better than baseline
  - For moderate failure rates (λ⁻¹ ≥ 5000s)
  - With reasonable communication (R ≥ 50m)
- Extreme case (40 robots, 160 tasks):
  - Field-based: ~1400s completion time
  - Baseline: >2000s completion time

#let isDoneLeader = box[
  #figure(
    table(inset: (0.3em, 0.1em), stroke: none, columns: (1fr, 1fr), align: (center, center),
    [
      #figure(
        image("images/isDone_leader_20nodes_taskfact1.png", width: 80%,)
      )
    ],[
      #figure(
        image("images/isDone_leader_20nodes_taskfact2.png", width: 80%,)
      )
    ],[
      #figure(
        image("images/isDone_leader_40nodes_taskfact1.png", width: 80%,)
      )
    ],[
      #figure(
        image("images/isDone_leader_40nodes_taskfact4.png", width: 80%,)
      )
    ],
    ),
    // caption: text(size: 13pt)[
    //   #figure(
    //     image("images/replanning_count_legend.png", width: 60%,)
    //   )
    // ]
  )
]

== Key Results - Trade-offs

#isDoneLeader
#figure(
  image("images/isDone_legend.png", width: 35%,)
)

- Gossip approach:
  - Higher replanning overhead (order of magnitude more events)
  - Superior resilience under high failure rates
  - Every robot monitors and may trigger replanning
- Leader approach:
  - More computationally efficient
  - Centralized replanning management
  - Vulnerable during leader transitions
- Corner cases: Field-based may underperform with rare failures
  - Monitoring overhead when failures are uncommon
  - Distributed consensus introduces latency

== Conclusion

- Field-based approaches significantly outperform late-stage baseline
  - When communication range is sufficient (≥50m)
  - When failures are realistic concern
- Key trade-off: resilience vs. computational efficiency
  - Gossip: high resilience, high overhead
  - Leader: efficient, vulnerable to transitions
- Limitation: dependency on communication connectivity
- Future work: hybrid approaches, hierarchical coordination, real robot validation



#let qr =  box[
  #figure(
    table(inset: (0.7em, 0.7em), stroke: none, columns: (1fr), align: (center),
    [*Reproducible experiments here!*],
    [
      #figure(
        image("images/repo-qr.svg", width: 30%,)
      )
    ],[
      Github repository: \@ angelacorte/experiments-2025-acsos-robots
    ],
  )
  )
]

== Experiments Repository

#qr

