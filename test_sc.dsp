import("stdfaust.lib");
import("detection.lib");
frame = .01;
process = (os.osc(1000) , no.noise) <: par(i, 2, sc(1, frame)) , par(i, 2, sc(2,
frame)) , par(i, 2, sc(4, frame));
