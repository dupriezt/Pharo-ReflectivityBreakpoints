# Pharo-ReflectivityBreakpoints
Improving Reflectivity breakpoints 

## Breakpoint Observer

Observers can register to the Breakpoint class using the `registerObserver:` and `unregisterObserver:` methods.

These observers will receive notifications objects holding the affected breakpoint and a collection of nodes on which it is installed or removed from.

Notifications are either a `BreakpointAddedNotification` or a `BreakpointRemovedNotification`.

To get all breakpoints present in the system: 
```Smalltalk
Breakpoint all
```

To know where a breakpoint is installed (for example here with the first one): 
```Smalltalk
Breakpoint all first node. "gets the AST node on which the breakpoint is installed"
Breakpoint all first node methodNode. "gets the method node in which the breakpoint is installed"
```
