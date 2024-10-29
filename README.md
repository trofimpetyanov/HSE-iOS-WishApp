HW-2 Questions

* What issues prevent us from using storyboards in real projects?  
  Merge conflict problems, performance issues in large projects, difficult to debug.

* What does the code on lines 25 and 29 do?  
  Turns off authorizing mask to enable manual constraints, sets text and font, adds label to the superview.

* What is a safe area layout guide?  
  It contains anchors for safe area, an area in which all the UI elements should be in order to display normally, ex. it has a padding from the dynamic island.

* What is [weak self] on line 23 and why it is important?  
  To prevent retain cycle (cycle where two objects have a strong reference to one another resulting in memory leaks).

* What does clipsToBounds mean?  
  When it is turned on, all the subviews will not stick out from the super view.

* What is the valueChanged type? What is Void and what is Double?  
  It is a closure. Double is the type of the parameter and Void is the return type.
