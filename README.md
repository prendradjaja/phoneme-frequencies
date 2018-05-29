## Quick links
- [Phonemes by frequency](local_target/q1_frequencies)
- [Phonemes by frequency post-/w/](local_target/q2_post_w_frequencies)
- [Words by count in BNC with pronunciations](local_intermediate/correlated_ipa_no_spaces)

## Summary
An estimate of the relative frequencies of English phonemes.
Also, an estimate of the relative frequencies of English phonemes
that follow /w/.

## Methodology
Reproducing the work of [Doug Blumeyer][blumeyer], I correlated the [CMU
Pronouncing Dictionary ("CMUdict")][cmudict] and [Adam Kilgarriff's
unlemmatized frequency list][kilgarriff] for the British National Corpus to
find phoneme frequencies generally. I extended this technique to
estimate post-/w/ phoneme frequencies as well.

## Limitations
As Blumeyer notes, the source datasets have some limitations.
CMUdict conflates "schwa with the near-open central vowel" and
has "several noticeable errors." Kilgarriff's frequency list has
some formatting issues that make it hard to work with words with
accents and apostrophes, (at this time, I've completely ignored
this issue) including common contractions.

Blumeyer did manual error checking on several hundred of the
most common words. I have not done this.

The CMUdict has multiple pronunciations for some words. For
these words, I used only the first pronunciation given. It's not
clear to me if in these cases the multiple pronunciations are
ordered in some way or just ordered arbitrarily.

## Other notes
While the Kilgarriff list is for the British National Corpus, a
quick inspection suggests that it uses American pronunciations
over British ones.

## References
- Doug Blumeyer, ["Relative Frequencies of English Phonemes"][blumeyer]
- [CMU Pronouncing Dictionary][cmudict] (Local copy at version 0.7b. Retrieved May 28, 2018.)
- Adam Kilgarriff, [word frequencies for the BNC][kilgarriff] (Local copy retrieved May 28, 2018.)

[blumeyer]: https://cmloegcmluin.wordpress.com/2012/11/10/relative-frequencies-of-english-phonemes/
[cmudict]: http://www.speech.cs.cmu.edu/cgi-bin/cmudict
[kilgarriff]: http://www.kilgarriff.co.uk/bnc-readme.html
