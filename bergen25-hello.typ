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
    title: [Engineering Collective Adaptive Systems],
    subtitle: [Language-based approach to programming "swarms" of devices],
    author: author_list(
      (
        (first_author("Gianluca Aguzzi"), "gianluca.aguzzi@unibo.it"),
      ), logo: "images/disi.svg"
    ),
    date: datetime(day: 31, month: 03, year: 2025).display("[day] [month repr:long] [year]"),
    // institution: [University of Bologna],
    // logo: align(right)[#image("images/disi.svg", width: 55%)],
  ),
)

#set text(font: "Fira Sans", weight: "light", size: 20pt)
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

== Hello, Bergen! :)

#components.side-by-side(columns: (1fr, 2fr), gutter: 0em)[
  #block(clip: true, radius: 50%, stroke: 0.5em + rgb("#eb811b5f"))[#figure(image("images/myself.jpeg", width: 85%))]
][
  === Gianluca Aguzzi

  - Postdoctoral Reseacher at the _University of Bologna_ (Cesena)
  - Adjust professor on topics related to OOP and FP and AI-based software engineering
  - Researcher at the #emph[Pervasive Software Lab] \ #fa-globe() #h(0.4em) #text(blue)[#link("https://pslab-unibo.github.io")] (prof. Mirko Viroli)

  === Research Scope and Interests
  - Macroprogramming languages for _collective adaptive systems_
    - Focus - _Swarm programming_
  - Automated design for collective behaviors
  - Integration of #emph[AI] and #emph[ML] with collective programming paradigms
]

= Shaping Tomorrow's Systems
== Vision of Future Technologies
#components.side-by-side(columns: (1fr, 1fr, 1fr))[
  #figure(image("images/smart-city.jpeg", height: 60%))
][
  #figure(image("images/crowd.jpeg", height: 60%))
][
  #figure(image("/images/drones.jpeg", height: 60%))
]

== What they have in common?
- A plethora of _devices_ and _services_ that need to work together
  - *Autonomous* and *distributed* systems
    - E.g., autonomous vehicles, smart cities, drones, IoT
  - *Heterogeneous* components with varying capabilities and resources
    - E.g., sensors, actuators, mobile devices, cloud services
  - Need for *autonomous decision-making* at both local and global levels
    - E.g., balancing global traffic optimization while satisfying individual routing needs
  - *Coordination challenges* across different spatial and temporal scales
    - E.g., traffic may be congested in one area while free-flowing in another
- The focus of these systems is on the #emph[collective behavior] rather than on individual _devices_
== Collective Systems

#quote[Complex systems composed of a large number of #underline[devices] that interact each other to achieve a global #underline[common goal]] #cite(label("DBLP:conf/birthday/BucchiaroneM19"))

=== Design challenges

#components.side-by-side[
  - #emph[Heterogeneity]: #text(size: 18pt)[Different types of devices with different capabilities]
  - #emph[Scalability]: #text(size: 18pt)[Systems can be composed of thousands of devices]
  - #emph[Dynamicity]: #text(size: 18pt)[Devices can join and leave the system at any time]
][
  #figure((image("images/step-11.png", width: 70%)))
]

== How? Macroprogramming for Collective Systems

#components.side-by-side(columns: (1fr, 1fr))[
  === Core Idea

  A *single program* #math.text("P") describes the _collective_ *self-org* behavior of the system.

  - #emph[Macroprogramming] abstractions
    - _Spatial_ and _temporal_ operators
  - #emph[Proximity-based] interactions
  - Resilient #emph[coordination] mechanisms
][
  #figure((image("images/scr-result.png", width:100%)))
]

#v(1.5em)

#align(center)[
  Shift from a #underline[device-centric] to a *collective-centric* view of the system.

  #underline[Aggregate Computing] #cite(label("DBLP:journals/computer/BealPV15")) as a way to program such systems.
]

== Aggregate Computing -- In a nutshell
#components.side-by-side(columns: (1fr, 1fr, 1fr), gutter: 1em, align: bottom)[
  === Field Calculus Core
  
  #quote[A #emph[field] is a *distributed* data structure that associates a _value_ to each _device_ in the system]#cite(label("DBLP:conf/coordination/AudritoBDV18"))
  
  #set list(marker: box(fill: rgb("#eb811b5f"), inset: 0.15em, text(size: 0.7em, rgb("#23373b"), [→])))
  - Based on *computational fields*
  - Provides abstractions for:
    - #text(size: 18pt)[Spatial computations]
    - #text(size: 18pt)[Collective behaviors]
    - #text(size: 18pt)[Self-organization]
][
  === Field Composition
  
  #set list(marker: box(fill: rgb("#eb811b5f"), inset: 0.15em, text(size: 0.7em, rgb("#23373b"), [→])))
  - Fields can be *composed* through standard operations
  - Functions map input fields to output fields 
  - #emph[Functional approach] to distributed computing
  
  #figure(image("images/channel.svg", width: 60%))
][
  #v(-3em)
  === Execution Model
  
  #set list(marker: box(fill: rgb("#eb811b5f"), inset: 0.15em, text(size: 0.7em, rgb("#23373b"), [→])))
  - #emph[Behaviour]: async rounds  
  - #emph[Interaction]: neighbour messaging
  - #emph[Alignment]: AST-based alignment
  
  #figure(image("images/ac.svg", width: 80%))
]

== Field Calculus
#align(center)[
  #figure(image("images/field.png", width: 40%))
]
#quote[A #emph[field] is a *distributed* data structure that associates a _value_ to each _device_ in the system]#cite(label("DBLP:conf/coordination/AudritoBDV18"))

#components.side-by-side[
  === Neighboring
  ```scala
  val f = nbr(10.0)
  //> f: Field[Double]
  ```
][
  === Repeating
  ```scala
  val a = rep(0): it =>
    it + 1
  ```
][
  === Branching
  #v(0.42em)
  ```scala
  branch(cond) { nbr(0) } { 
    nbr(Int.MaxValue)
  }
  ```
]
== Aggregate Programming

#components.side-by-side(columns: (2fr, auto))[
  === Field Composition
  ```scala
  def channel(source: Boolean, destination: Boolean): Boolean {
    val toSource = gradient(source) // Field[Double]
    val toDestination = gradient(destination) // Field[Double]
    val distance = distanceTo(source, destination)
    (toSource + toDestination - distance) <= 10
  }
  ```

  Functions take #emph[fields] as *input* and return #emph[field] as *output*.
][
  #figure(image("images/channel.svg", height: 45%))
]

//#v(0.5em)

The entire (_macro_-)program is executed by #emph[all the devices] in the network, assuming that each device *should* execute #emph[all] the functions.

== Self-organizing Computational Model

#emph[Behaviour]: execution with #underline[async rounds] \
#emph[Interaction]: *neighbours* #underline[messages exchange] \
#emph[Alignment]: each device execution is *aligned* with the others (program _AST_ alignment)

#line(length: 100%, stroke: 0.05em + rgb("#23373b"))

#only(1)[
  1. Receiving *messages* from neighbours
  #figure(image("images/ac-messages-perception.svg", width: 74%))
]
#only(2)[
  2. Computation of the *macro-program* against the received messages
  #figure(image("images/ac-computation.svg", width: 74%))
]
#only(3)[
  3. Sending to neighbours the *computed* messages
  #figure(image("images/ac-messages-propagation.svg", width: 74%))
]

#only(4)[
  4. Sleep until next *round*...
  #figure(image("images/ac.svg", width: 74%))
]

== Theoretical Foundations
=== Self-stabilization
#quote[The system is able to recover from any transient fault, without external intervention] #cite(label("DBLP:conf/coordination/AudritoBDV18"))
=== Eventual consistency
#quote[The system self-stabilizes to a predictable limit state as device density and speed increase #cite(label("7774387"))]
=== Space-time Universality
#quote[The system is able to compute any computable function, given enough time and space])

== Research Area
#let research-block(title, items) = block(
  stroke: 2pt + gray.darken(20%),
  fill: rgb("#eb811b5f").lighten(50%),
  radius: 0em,
  inset: 1em,
  width: 100%,
  height: 25%
)[
  #v(-0.5em)
  #set text(size: 18pt, weight: "bold", style: "italic")
  #title
  #v(-0.5em)
  #line(length: 100%, stroke: 0.5pt + gray.darken(20%))
  #v(-0.5em)
  #set text(size: 16pt, weight: "light", style: "normal")
  #items
]
#components.side-by-side(columns: (1fr, 1fr, 1fr))[
  #research-block("Applications", [
      #set text(size: 14pt)
      - #emph[Swarm Robotics ]#cite(label("aguzzi2023macroswarm"))
      - Smart cities
  ])
][
  #research-block("Cooperative Learning", [
    #set text(size: 14pt)
    - Proximity-based federated leanring#cite(label("DBLP:conf/acsos/DominiAFVE24"))
  ])
][
  #research-block("Hybrid Approach", [
    #set text(size: 14pt)
    - #emph[Field Informed Reinforcement Learning]
  ])
]
#components.side-by-side(columns: (1fr, 1fr))[
  #research-block("Runtime Monitoring", [
    #set text(size: 14pt)
    - Spatial Logics with for Runtime Monitoring
  ])
][
  #research-block("Programming Languauges", [
    #set text(size: 14pt)
    - Functional Reactive Programming for Aggregate
    - Visual programming for collective systems
  ])
]

#v(0.5em)

#only(2)[Something is missing?]

#focus-slide[
  *NO.*

  #only(2)[Thanks for your attention!]
  #only(3)[... April Fools! 🤪]
]

= Swarm Programming

== Swarm Programming -- An Aggregrate Programming Perspective
=== Swarm Programming Fundamentals

- #emph[Swarm Programming] enables coordinating multiple devices toward #underline[common goals]
  through collective intelligence

=== Behavior Classification

#set list(marker: box(fill: rgb("#eb811b5f"), inset: 0.15em, text(size: 0.7em, rgb("#23373b"), [→])))
- *Spatial Organization*: formation control, flocking, pattern creation
- *Task Allocation*: distributed resource management, workload distribution
- *Collective Decision-Making*: consensus building, distributed voting protocols

=== Aggregate Computing for Swarms

#components.side-by-side(columns: (3fr, 2fr))[
  - Field-based abstractions provide natural mapping to swarm coordination
  - Computational fields become both:
    - Input sensors capturing environmental data
    - Output controllers generating navigational potential fields
]
== Macro swarm
#block(
  fill: rgb("#f5f5f5"),
  inset: 1em,
  radius: 0.5em,
  width: 100%,
)[
  #set text(style: "italic")
  #align(center)[
    #text(weight: "bold", size: 1.1em)[MacroSwarm]
  ]
  
  A macro programming approach based on #emph[Aggregate Computing] (field-based coordination) 
  for programming swarm behaviors in a #text(rgb("#eb811b"))[modular] and #text(rgb("#eb811b"))[scalable] way.
]
#components.side-by-side(columns: (1fr, 1fr))[
  === Architecture
  #image("images/overview-macroswarm.png", width: 100%)
][
  === MacroSwarm -- examples
  #image("example-of-movement.png", width: 70%)
]
== Pattern Formation Convergence -- Quasi-Static Approximation

=== Quasistatic Approximation for Formation Convergence

#definition[
  An event structure `E` over devices `Delta` performs a #emph[quasistatic evolution] for a self-stabilizing field computation `f` if:
  
  1. The network topology remains stable in intervals `[t_i, t_{i+1}]`
  2. The movement field `f` converges before significant position changes occur
]

- Assumes computation is fast compared to movement
- Provides baseline for convergence guarantees
- Extend self-stabilization to dynamic environments

== Application -- Wildfire Monitoring

Our approach enables effective monitoring of wildfire progression in forest areas #cite(label("DBLP:conf/acsos/GrushchakKPFABS24")):

- Real-time drone coordination for persistent surveillance
- Adaptive formation patterns based on fire spread dynamics
- Data collection from multiple environmental sensors

#components.side-by-side(columns: (3fr, 2fr))[
  - System validated with realistic simulation data from wildfire scenarios (zebras)
  - Coordinates multiple drones to maximize the animals' visibility
  - Enables quick response to emerging hotspots through adaptive formations
][
  #figure(
    image("images/wildlife.png", width: 80%),
  )
]

== Researcher Night Demo
=== Live Demonstration

We presented MacroSwarm at European Researcher Night 2024, showcasing real-time pattern formation and coordination with multiple drones. 

#components.side-by-side(columns: (1fr, 1fr))[
  === Demo Setup

#image("images/base-setting.png", width: 60%)
][
  === Demo in Action

  #image("images/example-result.png", width: 80%)
]

== Open Challenges - Stronger Guarantees
=== Limitations of Current Approach

- #emph[Quasistatic approximation] presents theoretical limitations:
  - Assumes stable network topology during computation cycles
  - Requires computation speed to significantly exceed movement dynamics
  - Breaks down in highly dynamic or adversarial environments

=== Research Frontiers

- Need for #emph[adaptive formation semantics]:
  - Beyond static formations to fully dynamic, objective-driven patterns
  - Continuous reconfiguration based on environmental feedback
  - Resilience against device failures and communication disruptions

== Open Challenges - Formation Composition
=== Formation Composition Challenges

- *Composition* for building complex behaviors from simpler ones
  - Current limitations: monolithic pattern designs with limited reuse

#components.side-by-side(columns: (1fr, 1fr))[
  === Research Questions
  - What are the primitive building blocks for swarm formations?
  - How to define compositional operators preserving formation properties?
  - Can we ensure convergence guarantees when combining formations?
][
  === Inspiration
  - Origami programming model #footnote[#link("https://groups.csail.mit.edu/mac/projects/amorphous/Progmat/thesis/origami-global.html")]
  - Algebraic approaches to spatial pattern composition
  - Field calculus composition principles
]

== 
== Conclusion
= Conclusion

== Takeaways

#components.side-by-side(columns: (1fr, 1fr))[
  === What We've Covered
  - *Collective Systems* as a paradigm for future computing
  - *Aggregate Programming* as a principled approach to swarm coordination
  - *Field Calculus* abstractions for spatial computations
  - These slides: Focus on *swarm programming* and *pattern formation*
][
  === Future Directions
  - Scaling to larger and more heterogeneous systems
  - Stronger guarantees for dynamic environments
  - Improving robustness in highly dynamic environments
  - Bridging the gap between simulation and real-world deployment
  - Democratizing collective programming with better tools and abstractions
]

== Takeaways
#quote[The future of computing isn't about individual devices, but about the emergent intelligence of their collective behavior.]

#align(center)[
  #v(1em)
  #emph[Thank you for your attention!]
  #v(0.5em)
  Questions? Comments?
  #v(0.5em)
  #text(blue)[#link("mailto:gianluca.aguzzi@unibo.it")]
]