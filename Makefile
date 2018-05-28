.PHONY: clean all

all: correlated

clean:
	rm kilgarriff_* cmudict_* correlated uncorrelated


############################################################

cmudict:
	curl http://svn.code.sf.net/p/cmusphinx/code/trunk/cmudict/cmudict-0.7b > cmudict

kilgarriff:
	curl http://www.kilgarriff.co.uk/BNClists/all.al.gz | gunzip > kilgarriff

# kilgarriff.num::
# 	curl http://www.kilgarriff.co.uk/BNClists/all.num.gz | gunzip > kilgarriff.num



############################################################

cmudict_05_no_comments: cmudict
	cat cmudict | grep --text -v '^;;;' > cmudict_05_no_comments

cmudict_07_remove_bad_unicode: cmudict_05_no_comments
	cat cmudict_05_no_comments | grep --text -v 'D EY2 JH AA1' > cmudict_07_remove_bad_unicode

cmudict_10_first_only: cmudict_07_remove_bad_unicode
	cat cmudict_07_remove_bad_unicode | grep --text -v '^[^ ]*\([0-9]\)' > cmudict_10_first_only

cmudict_20_discard_stress: cmudict_10_first_only
	cat cmudict_10_first_only | ./discard_stress.py > cmudict_20_discard_stress

cmudict_processed: cmudict_20_discard_stress
	cp cmudict_20_discard_stress cmudict_processed



############################################################

kilgarriff_05_discard_fields: kilgarriff
	cat kilgarriff | awk '{print $$1, $$2}' > kilgarriff_05_discard_fields

kilgarriff_07_discard_total: kilgarriff_05_discard_fields
	cat kilgarriff_05_discard_fields | sed '1d' > kilgarriff_07_discard_total

kilgarriff_10_squashed: kilgarriff_07_discard_total
	cat kilgarriff_07_discard_total | ./squash_kilgarriff.py > kilgarriff_10_squashed

kilgarriff_20_sorted: kilgarriff_10_squashed
	cat kilgarriff_10_squashed | sort --numeric-sort --reverse > kilgarriff_20_sorted

kilgarriff_processed: kilgarriff_20_sorted
	cp kilgarriff_20_sorted kilgarriff_processed



############################################################

# This rule also generates the `uncorrelated` file, but I'm not
# sure how to represent this in Make syntax.
correlated: kilgarriff_processed cmudict_processed
	./make_correlated.py



############################################################

# q1_frequencies: correlated
# 	cat correlated | ./compute_frequencies.py > 
