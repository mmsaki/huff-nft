# Specifications

> "Two different engineers with the same spec should be able to produce fuctionally equivalent implementations without communicating as long as they have that same spec whatever they Implement in whatever language the same input should map to the same outputs" - mohammadfawaz

Specifications should constrain:

1. Application Binary Interface (ABI)
   1. Functions
   1. Events
1. Behavior of each valid function
   1. Branches and their thresholds
   1. Exceptional cases
   1. Event logs
      > branches and thresholds these are things like what do you do if a balance is above a certain amount or if a number is greater than or less than that thing. Let's say you want to make a transfer, what happens if your balance is less than the amount. What exactly should happen? Obviously we know it's an exception but that's something that should be constrained by the specification.
1. Properties
   1. Invariants
   1. Assumptions
      > Your invariance are expressions that should always evaluate the true, in the case of uniswap you know x times y equals K, that's something that you can check and if it evaluates defaults then we know that the invariant is broken. Assumptions are not quite as serious as invariance, they are assumptions that we make about general behavior that if violated it doesn't break anything it's just something that would kind make life easier. We assume that you know things are encoded the correct way, at face value if something breaks something breaks the idea is that you know our specification should constrain that if something should break it will break.

## Incremental implementations

> "Your tests should be written such that any change that does NOT cause a test failure is a valid change." - andi metz, sorta

### Crawl then walk

1. Implement the spec in a high level language
1. write full test suite for hll impl.
   1. Concrete Tests
   1. Stateless Fuzzing
   1. Stateful Fuzzing (Invariants)
1. Optimize the impl with inline assembly (if possible)
1. Assert all tests pass BEFORE the next step

### Walk then run

1. Implement the spec in Huff
1. Match the reference impl's ABI
1. Assert all tests still pass

### Run then Fly

> Wait you still need more gas optimizations?

1. Write your own ABI encoding

   1. To interface with it in tests, use an encorder library in solidity
      > maybe some custom data types, you should be able to get a ton of gas savings out of an ABI encoding because call data is actually surprisingly expensive

1. Unroll loops with a known upper bound
1. Optimize the stack schedule see [Treegraph-based Instruction Scheduling for Stack-based Virtual Machines](https://www.sciencedirect.com/science/article/pii/S1571066111001538)
   > the idea was right is that you can create a graph of op codes um and that graph is structured in such a way that if you do a depth first traversal it'll generate the optimal stack schedule and so this is a really deep research stuff how this stuff works and why it works
   > the idea is that you want to minimize obviously duplication, minimize swapping, you want to set the stack up in such a way that you know you have to do the minimal operations
1. Read compiler optimization rules see [Solidity optimizer rules](https://github.com/ethereum/solidity/blob/develop/docs/internals/optimizer.rst)
   > read compiler optimization rules, every evm compiler out there has a back end or an intermediate representation and somewhere in there is an Optimizer sometimes it's called simplification rules. See [Yul optimizer rules](https://github.com/ethereum/solidity/blob/develop/docs/yul.rst#yul-optimizer)

## Documentation and periphery

1. Add stack comments to every line with an opcode
1. Document every macro, fn, and const
   1. Explain the high level procedures
   1. Declare invariants
   1. Declare assumptions
   1. Declare conditions that revert the tx
1. No amount of documentation is too much documentation

**Readability**

1. Align opcodes
1. Avoid multiple opcodes per line
1. Indent conditional blocks
1. Follow consistent naming of constants and macros
   1. storage slot: `N_SLOT`
   1. selector: `N_SEL`
   1. pointers: `N_PTR`
   1. type castion: `TO_DATATYPE`
   1. library: `libN`

**Periphery**

1. If the ABI is the same as Solc:
   1. all clients libraries should be able to interface with it off chain
   1. standard solc interfaces can be used to interface with it on chain
1. Else:
   1. write a minimal client library to interface with it off chain
   1. write a minimal library or custom data type to interface with it on chain
