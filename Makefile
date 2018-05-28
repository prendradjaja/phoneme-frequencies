.PHONY: clean all

all: intermediate/correlated_ipa target/q1_frequencies target/q2_post_w_frequencies

clean:
	rm -f source/* intermediate/* target/*


############################################################

source/cmudict:
	curl http://svn.code.sf.net/p/cmusphinx/code/trunk/cmudict/cmudict-0.7b > source/cmudict

source/kilgarriff:
	curl http://www.kilgarriff.co.uk/BNClists/all.num.gz | gunzip > source/kilgarriff



############################################################

# ;;; # CMUdict
# CAT  K AE1 T
# READ  R EH1 D
# READ(1)  R IY1 D
# THE  DH AH0
# ZOO  Z UW1

intermediate/cmudict_05_no_comments: source/cmudict
	cat source/cmudict | grep --text -v '^;;;' > intermediate/cmudict_05_no_comments

# CAT  K AE1 T
# READ  R EH1 D
# READ(1)  R IY1 D
# THE  DH AH0
# ZOO  Z UW1

# There's what looks like bad unicode in exactly one entry in
# cmudict. (Something like "DEJA". "DEJA" in all ASCII is in fact
# present.) It's probably OK to just remove this entry entirely.
intermediate/cmudict_07_remove_bad_unicode: intermediate/cmudict_05_no_comments
	cat intermediate/cmudict_05_no_comments | grep --text -v 'D EY2 JH AA1' > intermediate/cmudict_07_remove_bad_unicode

intermediate/cmudict_10_first_only: intermediate/cmudict_07_remove_bad_unicode
	cat intermediate/cmudict_07_remove_bad_unicode | grep --text -v '^[^ ]*\([0-9]\)' > intermediate/cmudict_10_first_only

# CAT  K AE1 T
# READ  R EH1 D
# THE  DH AH0
# ZOO  Z UW1

intermediate/cmudict_20_discard_stress: intermediate/cmudict_10_first_only
	cat intermediate/cmudict_10_first_only | ./discard_stress.py > intermediate/cmudict_20_discard_stress

# CAT  K AE T
# READ  R EH D
# THE  DH AH
# ZOO  Z UW

intermediate/cmudict_processed: intermediate/cmudict_20_discard_stress
	cp intermediate/cmudict_20_discard_stress intermediate/cmudict_processed

# CAT  K AE T
# READ  R EH D
# THE  DH AH
# ZOO  Z UW



############################################################

# 36 !!WHOLE_CORPUS !!ANY 10
# 20 the at0 5
# 10 read vvx 3
# 5 read vvy 2
# 1 zoo nn1 1

intermediate/kilgarriff_05_discard_fields: source/kilgarriff
	cat source/kilgarriff | awk '{print $$1, $$2}' > intermediate/kilgarriff_05_discard_fields

# 36 !!WHOLE_CORPUS
# 20 the
# 10 read
# 5 read
# 1 zoo

intermediate/kilgarriff_07_discard_total: intermediate/kilgarriff_05_discard_fields
	cat intermediate/kilgarriff_05_discard_fields | sed '1d' > intermediate/kilgarriff_07_discard_total

# 20 the
# 10 read
# 5 read
# 1 zoo

intermediate/kilgarriff_10_squashed: intermediate/kilgarriff_07_discard_total
	cat intermediate/kilgarriff_07_discard_total | ./squash_kilgarriff.py > intermediate/kilgarriff_10_squashed

# 20 the
# 15 read
# 1 zoo

intermediate/kilgarriff_20_sorted: intermediate/kilgarriff_10_squashed
	cat intermediate/kilgarriff_10_squashed | sort --numeric-sort --reverse > intermediate/kilgarriff_20_sorted

intermediate/kilgarriff_processed: intermediate/kilgarriff_20_sorted
	cp intermediate/kilgarriff_20_sorted intermediate/kilgarriff_processed

# 20 the
# 15 read
# 1 zoo



############################################################

# This rule also generates the `uncorrelated` file, but I'm not
# sure how to represent this in Make syntax.
intermediate/correlated_arpa: intermediate/kilgarriff_processed intermediate/cmudict_processed
	./make_correlated.py intermediate/cmudict_processed intermediate/kilgarriff_processed intermediate/correlated_arpa intermediate/uncorrelated

# 20 the  DH AH
# 15 read  R EH D
# 1 zoo  Z UW

intermediate/correlated_ipa: intermediate/correlated_arpa
	cat intermediate/correlated_arpa | ./to_ipa.py > intermediate/correlated_ipa


############################################################

target/q1_frequencies: intermediate/correlated_ipa
	cat intermediate/correlated_ipa | ./compute_frequencies.py > target/q1_frequencies

target/q2_post_w_frequencies: intermediate/correlated_ipa
	cat intermediate/correlated_ipa | ./compute_post_w_frequencies.py > target/q2_post_w_frequencies
