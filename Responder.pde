import java.util.Set;
import java.util.HashSet;

/**
* Generic object for a ripple item that expands on clicks and induces activation in neighbors
**/
class Responder {
  // The three states a responder can be in
  private final String DORMANT = "dormant";  // Chillin
  private final String WARMING = "warming";  // Activated and getting hot
  private final String COOLING = "cooling";  // Calming down
  
  // Tunable parameters
  private final float WARMING_SECS = 1.0;
  private final float COOLING_SECS = 1.4;
  private final float PROPAGATION_DELAY_SECS = 0.9;
  
  private String state = DORMANT;
  
  private boolean propagated;
  
  // Attributes
  private int frameStart;
  private int x, y;
  private float radius, offRadius, onRadius;
  private int warmingFrames, coolingFrames, propagationDelayFrames;
  
  // The responders immediately adjacent
  private Set<Responder> neighbors;
  
  Responder(int x, int y, float offRadius, float onRadius) {
    fill(25, 50, 70, 200);
    this.x = x;
    this.y = y;
    this.radius = offRadius;
    this.offRadius = offRadius;
    this.onRadius = onRadius;
    this.neighbors = new HashSet<Responder>();
    warmingFrames = secsToFrames(WARMING_SECS);
    coolingFrames = secsToFrames(COOLING_SECS);
    propagationDelayFrames = secsToFrames(PROPAGATION_DELAY_SECS);
  }
  
  void addNeighbor(Responder neighbor){
    neighbors.add(neighbor);
  }
  
  int getX() {
    return x;
  }
  
  int getY() {
    return y;
  }
  
  float getRadius() {
    return radius;
  }
  
  boolean isDormant() {
    return state == DORMANT;
  }
  
  boolean isWarming() {
    return state == WARMING;
  }
  
  boolean isCooling() {
    return state == COOLING;
  }
  
  /*
  * Checks if a given x or y coordinate lies in the area of this responder
  */
  boolean inResponder(int x, int y) {
     boolean inX = x > getX() - getRadius() && x < getX() + getRadius();
       
     float distance = Math.abs(x - getX());
     float yDiff = getRadius() * sin(acos(distance/getRadius())); 
     
     boolean inY = y > getY() - yDiff && y < getY() + yDiff;
     
     return inX && inY;
  }
  
  /*
  * Switches this responder to warming state
  */
  void activate() {
    if (!isDormant()) return;
    
    state = WARMING;
    resetTimer();
  }
  
  /*
  * (1) If dormant, don't change the appearance
  * (2) As it's warming, make it expand to the size of onRadius
  * (3) Once we're past the propagation delay threshold, activate the other responders
  * (4) When cooling, contract back to normal size
  */
  void display() {
    if (!isDormant()) {
      if (isWarming() && !pastFrames(warmingFrames)) {
        float increment = (onRadius - offRadius) / warmingFrames;
        radius += increment;
      } else if (isWarming() && pastFrames(warmingFrames)) {
        state = COOLING;
        radius = onRadius;
        resetTimer();
      }
      
      if (!propagated && !isDormant() && pastFrames(propagationDelayFrames)) {
        for (Responder neighbor : neighbors) {
          neighbor.activate();
        }
        propagated = true;
      }
      
      if (isCooling() && !pastFrames(coolingFrames)) {
        float decrement = (onRadius - offRadius) / coolingFrames;
        radius -= decrement;
      } else if (isCooling() && pastFrames(coolingFrames)) {
        state = DORMANT;
        propagated = false;
        radius = offRadius;
        resetTimer();
      }
    }
    
    float diameter = 2 * radius;
    ellipse(x, y, diameter, diameter);
  }
  
  /*
  * Call this to measure frames past since current count
  */
  void resetTimer() {
    frameStart = frameCount;
  }
  
  /*
  * True if the number of frames past start exceeds a threshold
  */
  boolean pastFrames(int frames) {
    return (frameCount - frameStart) > frames;
  }
  
  /*
  * Number of frames passed
  */
  int timerFrames() {
    return frameCount - frameStart;
  }
  
  /*
  * Number of seconds passed
  */
  float timerSecs() {
    return new Float(frameCount - frameStart) / new Float(frameRate);
  }
}
