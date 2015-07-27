/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.multiplehypothesis.simpletracker;

import static java.lang.Math.*;
import org.apache.log4j.Logger;
import java.util.Random;

/**
 *
 * @author David Miguel Antunes davidmiguel [ at ] antunes.net
 */
public class Target {

    private static final Logger logger = Logger.getLogger(Target.class);
    private double x, y, heading, velocity;

	Random generator = new Random(123);
	
    public Target() {
		System.out.println("\t" + 0.5 + "\n");
        x = 0.5 * 400;
        y = 0.5 * 400;
        heading = 0.5 * 2 * PI;
        velocity = 0.5 * 5;
    }

    public void update() {
        heading = (0.5 - 0.5) + heading;
        velocity = min(5, max(0, velocity + 0.5));
        x = min(390, max(10, x + velocity * cos(heading)));
        y = min(390, max(10, y + velocity * sin(heading)));
    }

    public double getX() {
        return x;
    }

    public double getY() {
        return y;
    }
}
