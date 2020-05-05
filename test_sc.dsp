import("stdfaust.lib");
import("detection.lib");

process = (os.osc(1000) , no.noise) <: par(i, 2, sc(1, .01)) , par(i, 2, sc(2,
.01)) , par(i, 2, sc(4, .01));
