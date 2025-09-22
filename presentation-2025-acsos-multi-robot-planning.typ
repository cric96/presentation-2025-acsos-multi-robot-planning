#import "@preview/touying:0.6.1": *
#import "themes/theme.typ": *
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

#show: theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  config-common(
    handout: false,
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

#set text(font: "Fira Sans", size: 18pt)
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

// Emphasis helper: bold + italic + accent color
#let emph(content) = text(style: "italic", fill: rgb("#E44F14"), content)
// #let underline(content) = text(style: "underline", fill: rgb("#1bb0eb"), content)
#show link: set text(hyphenate: true)
// Definition panel: a titled box with description content (gray theme)
#let defblock(title, description) = box(
  fill: rgb("#f5f5f5"),
  stroke: (left: (thickness: 4pt, paint: rgb("#9e9e9e")), rest: none),
  radius: 0.6em,
  inset: (x: 1em, y: 0.7em),
  width: 100%,
)[
  #block(spacing: 0.4em)[
    #text(weight: "bold", fill: rgb("#424242"))[Definition — *#title*:]
    #description
  ]
]

#let infoblock(
  title,
  description,
  primary: rgb("#9E9E9E"),
  elevation: 2,
) = box(
  // Gray theme card with top title bar
  fill: rgb("#f5f5f5"),
  stroke: (rest: (thickness: 0.6pt, paint: rgb("#E0E0E0"))),
  radius: 0.7em,
  width: 100%
)[
  // Top header
  #box(
    fill: primary,
    inset: (x: 1.2em, y: 0.6em),
    width: 100%,
  )[
    #text(weight: "semibold", fill: rgb("#FFFFFF"))[#title]
  ]

  // Body (reduced padding)
  #box(inset: (x: 1.2em, top: -0.5em, bottom: 0.5em))[
    #text(fill: rgb("#424242"))[#description]
  ]
]


// #set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

// == Outline <touying:hidden>

// #components.adaptive-columns(outline(title: none, indent: 1em))

= Introduction


== Reference Scenario - Search and rescue mission in disaster zones
// Picture 40 autonomous robots in a disaster zone -- Figure

#let referenceScenario = box[
  #table(inset: (0.5em, 0.7em), stroke: none, columns: (0.9fr, 1fr), align: (left, left),
    [
      #figure(
        image("images/recovery-area.jpg", width: 100%),
      ) 
    ], [
      - A _Tsunami_ or _earthquake_ has hit a _city_ 
      #pause
      - Robots move *autonomously* to check #emph[damaged buildings] 
      #pause
      - They may already know some #emph[area information] (e.g., building locations)
      #pause
      - Communications: #underline[spotty], #underline[unreliable], #underline[low-bandwidth]
      #pause
      - ⚠️ Robots may *fail*: battery, sensors, actuators
      #pause
      - 🎯 Mission goal: check #emph[as many buildings as possible] in #emph[limited time] ⏱️
      #pause
      - How to #emph[coordinate] the robots❓
    ]
  )
]

#referenceScenario


== Multi-robot Planning Problem
#defblock([Multi-Robot Planning], [Given a set of *robots* and #underline[tasks] (e.g., buildings), produce a #emph[plan] that assigns tasks to robots and orders their execution.])
#pause
#defblock([Task], [A unit of work assigned to robots, completed when conditions are met.])
#pause
#defblock([Plan], [an ordered list of tasks assigned to each robot.])

#let centralProblem = box[
  #table(inset: (0.7em, 0.7em), stroke: none, columns: (0.3fr, 0.3fr), align: (left),
    [
      #figure(
        image("images/multi-robot-planning.jpg", width: 90%),
      )
    ],[
      #figure(
        image("images/warehouse-1.jpg", width: 80%),
      ) 
    ]
  )
]
#meanwhile
#centralProblem

== Multi-robot #underline[(Re)]-Planning Problem
#defblock([Replanning], [the process of updating an existing plan in response to changes in the environment or system state.])


#let whyReplanning = box[
  #table(inset: (0.7em, 0.7em), stroke: none, columns: (0.4fr, 0.3fr), align: (left),
    [
#pause
- Why replanning❓
  - ⚠️ Robots may #emph[fail] during the mission
  - ⚠️ Robots may discover #emph[new information] (e.g., new buildings, blocked roads)
  - ⚠️ The environment may change dynamically (e.g., aftershocks, weather conditions)
  - ⚠️ The initial plan may become #emph[inefficient] or #emph[infeasible]
  - *Goal*: adapt the plan to ensure #emph[mission success] despite changes

    ],[
      #figure(
        image("images/replanning.png", width: 100%),
      ) 
    ]
  )
]
#whyReplanning

== Problem Statement

- Team of $m$ robots $cal(R) = {r_1, dots, r_m}$ 
- Set of $n$ tasks $cal(T) = {t_1, dots, t_n}$ (e.g., buildings to check)
- Each task visited #underline[exactly once] by #underline[one robot]

#line(length: 100%, stroke: 1pt + gray)

*System Setup:*
- Robots start from source depots $Sigma$ and end at destination depots $Delta$
- Travel cost $omega_(i j r)$ between locations $i, j$ for robot $r$
- Service time $xi_(i r)$ for robot $r$ to complete task $i$

#line(length: 100%, stroke: 1pt + gray)

*Robot Constraints:*
- Limited communication range $R$
- Local sensing capabilities  
- Probability of #underline[failure] during mission

== Optimization Formulation

#defblock([Objective], [Minimize #underline[total mission completion time] across all robots])

$ min J = sum_(r in cal(R)) sum_(i in cal(T)^Sigma) sum_(j in cal(T)^Delta) (omega_(i j r) + xi_(i r)) x_(i j r) $

where $x_(i j r) in {0,1}$ indicates if robot $r$ travels from location $i$ to location $j$

#v(0.3em)
#line(length: 100%, stroke: 2pt + rgb("#9e9e9e"))
#v(0.3em)

#pause
*Key Constraints:*
- Each task → #underline[exactly one robot]: $sum_(r in cal(R)) sum_(i in cal(T)^Sigma) x_(i j r) = 1, forall j in cal(T)$
- #underline[Flow conservation]: robots that enter a task must exit it
- No #underline[subtours] disconnected from depots
- Start at source $Sigma$, end at destination $Delta$

== How to Replan?
#let howToReplan = box[
  #table(
    inset: (0.7em, 0.7em),
    stroke: none,
    columns: (1fr, 1fr),
    align: (top, top),
    [
      #infoblock([Centralized Replanning], [
        - #emph[Central entity] collects info from all robots and updates the plan.
        - 👍 *Pros:* considers #underline[global information], often #underline[high-quality plans].
        - 👎 *Cons:* #underline[single point of failure], #underline[high communication overhead].
      ])
    ],[
      #infoblock([Decentralized Replanning], [
        - Each robot updates its plan using #emph[local information].
        - 👍 *Pros:* #underline[scalable], #underline[no single point of failure].
        - 👎 *Cons:* may miss #underline[global context], #underline[coordination is hard].
      ])
    ]
  )
]
#howToReplan

#pause
#v(0.3em)
#line(length: 100%, stroke: 2pt + rgb("#E44F14"))
#v(0.3em)

- In disaster recovery, we focus on #emph[decentralized replanning]
- *Challenge*: how to achieve effective replanning strategy with #underline[limited communication] and #underline[local views]?
//- This is where our #emph[field-based approach] comes in! 🚀

== Greedy Replanning Algorithm

#defblock([Runtime Replanning], [When robots #underline[fail] → reassign remaining tasks to #underline[active robots] efficiently])

#v(0.2em)
#line(length: 100%, stroke: 1pt + gray)
#v(0.1em)

*Input:* Active robots $cal(R)_a subset.eq cal(R)$ (non-failed) | Remaining tasks $cal(T)_r subset.eq cal(T)$ (unassigned)

*Cost Function:* For each robot-task pair $(r_j, t_i)$:
$ C(t_i, r_j) = omega_("current"(r_j), i, r_j) + xi_(i r_j) + omega_(i, "next"(r_j), r_j) $

#pause
#v(0.2em)
#line(length: 100%, stroke: 2pt + rgb("#9e9e9e"))
#v(0.2em)

*Algorithm Steps:*
1. Find robot-task pair $(r^*, t^*)$ with #underline[minimum cost] $C(t_i, r_j)$
2. #underline[Assign] task $t^*$ to robot $r^*$ 
3. #underline[Remove] $t^*$ from remaining tasks $cal(T)_r$
4. #underline[Repeat] until all tasks assigned or no feasible assignments
#focus-slide()[
   Greedy replanning is #emph[simple] and #emph[fast].
  #pause
  
  But two challenges remain:
  #pause


    1️⃣ How do robots maintain a consistent system view with #underline[limited communication]?
    #pause
  

    2️⃣ How do robots decide #underline[when] to replan?
    #pause

    This is where our #emph[field-based approach] comes in!   🚀
]

= Contribution

== Field-based Replanning -- Overview
#figure(
  image("images/idea.svg", width: 90%),
)
== Aggregate Computing In a Nutshell
- Write the usual intro on AC

#figure(
  image("images/acDevices.svg", width: 80%),
)

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
      #align(center)[
        #text(size: 32pt, weight: "bold")[Thank You!]
      ]

    ],
  )
  )
]

== Experiments Repository

#qr
