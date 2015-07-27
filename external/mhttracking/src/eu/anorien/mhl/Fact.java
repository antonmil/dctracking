//Copyright (C) 2011 by David Miguel Antunes davidmiguel [ at ] antunes.net
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

package eu.anorien.mhl;

/**
 * <p>A fact is a "piece" of the state of the world. For example when the
 * application generates an event like "Ship #29384 moved from (183.23, 330.19)
 * to (187.94, 334.82) at 22:43 26/07/2015", it may also generate a fact like
 * "Ship #29384 is in (187.94, 334.82)".</p>
 *
 * <p>Contrary to events, facts are never sent to the application. They are kept
 * indefinitely by the library. However, when a fact is provided by the library
 * to the application in the context of an hypothesis generation, by the method
 * {@link eu.anorien.mhl.generator.HypothesesGenerator#generate(java.util.Set, java.util.Set) generate(Set<Event> events, Set<Fact> facts)}
 * the fact is deleted from the library. Even so, it can be restated by the
 * application by including it in the
 * {@link eu.anorien.mhl.generator.GeneratedHypothesis GeneratedHypothesis}.</p>
 *
 * <strong>Warnings:</strong>
 * <p>1. Facts should never be changed, after their creation. This can be
 * enforced if all fields are final, or all fields are private and only
 * getter methods are available.</p>
 * <p>2. Facts MUST implement the {@link java.lang.Object#hashCode() hashCode} and
 * the {@link java.lang.Object#equals(java.lang.Object) equals} methods.</p>
 *
 * @author David Miguel Antunes
 */
public interface Fact {
}