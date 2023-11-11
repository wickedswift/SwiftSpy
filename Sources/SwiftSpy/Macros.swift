@attached(member, names: arbitrary)
public macro Spy() = #externalMacro(module: "SwiftSpyMacros", type: "SpyMacro")
