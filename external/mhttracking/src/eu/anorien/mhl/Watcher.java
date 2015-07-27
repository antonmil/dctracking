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

import java.util.Collection;

/**
 * The application may register a Watcher, using the 
 * {@link HypothesesManager#register(eu.anorien.mhl.Watcher) register} method of
 * the {@link HypothesesManager HypothesesManager} class to: watch for changes
 * in the events and facts maintained by the library; receive confirmed facts
 * (with probability of 1); receive the current best hypothesis when it changes.
 * 
 * @author David Miguel Antunes davidmiguel [ at ] antunes.net
 */
public interface Watcher {

    /**
     * A new fact is now maintained in the library.
     */
    public void newFact(Fact fact);

    /**
     * Similar to {@link #newFact(eu.anorien.mhl.Fact) newFact}.
     */
    public void newFacts(Collection<Fact> facts);

    /**
     * A fact is no longer being maintained by the library, either because it
     * was pruned or deleted after being requested in an hypothesis generation.
     */
    public void removedFact(Fact fact);

    /**
     * Similar to {@link #removedFact(eu.anorien.mhl.Fact) removedFact}.
     */
    public void removedFacts(Collection<Fact> facts);

    /**
     * A new event is now maintained in the library.
     */
    public void newEvent(Event event);

    /**
     * Similar to {@link #newEvent(eu.anorien.mhl.Event) newEvent}.
     */
    public void newEvents(Collection<Event> events);

    /**
     * An event is no longer being maintained by the library, either because it
     * was pruned or confirmed to the application.
     */
    public void removedEvent(Event event);

    /**
     * Similar to {@link #removedEvent(eu.anorien.mhl.Event) removedEvent}.
     */
    public void removedEvents(Collection<Event> events);

    /**
     * @param event This event will no longer be maintained by the library, and
     * has now a probability of 1.
     */
    public void confirmedEvent(Event event);

    /**
     * Similar to {@link #confirmedEvent(eu.anorien.mhl.Event) confirmedEvent}.
     */
    public void confirmedEvents(Collection<Event> events);

    /**
     * @param hypothesis The new best hypothesis.
     */
    public void bestHypothesis(Hypothesis hypothesis);
}
