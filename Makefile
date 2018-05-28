.PHONY: clean all

all: correlated_ipa q1_frequencies q2_post_w_frequencies

clean:
	rm -f kilgarriff* cmudict* correlated_* uncorrelated


############################################################

cmudict:
	curl http://svn.code.sf.net/p/cmusphinx/code/trunk/cmudict/cmudict-0.7b > cmudict

kilgarriff:
	curl http://www.kilgarriff.co.uk/BNClists/all.num.gz | gunzip > kilgarriff



############################################################

# ;;; # CMUdict
# CAT  K AE1 T
# READ  R EH1 D
# READ(1)  R IY1 D
# THE  DH AH0
# ZOO  Z UW1

cmudict_05_no_comments: cmudict
	cat cmudict | grep --text -v '^;;;' > cmudict_05_no_comments

# CAT  K AE1 T
# READ  R EH1 D
# READ(1)  R IY1 D
# THE  DH AH0
# ZOO  Z UW1

# There's what looks like bad unicode in exactly one entry in
# cmudict. (Something like "DEJA". "DEJA" in all ASCII is in fact
# present.) It's probably OK to just remove this entry entirely.
cmudict_07_remove_bad_unicode: cmudict_05_no_comments
	cat cmudict_05_no_comments | grep --text -v 'D EY2 JH AA1' > cmudict_07_remove_bad_unicode

cmudict_10_first_only: cmudict_07_remove_bad_unicode
	cat cmudict_07_remove_bad_unicode | grep --text -v '^[^ ]*\([0-9]\)' > cmudict_10_first_only

# CAT  K AE1 T
# READ  R EH1 D
# THE  DH AH0
# ZOO  Z UW1

cmudict_20_discard_stress: cmudict_10_first_only
	cat cmudict_10_first_only | ./discard_stress.py > cmudict_20_discard_stress

# CAT  K AE T
# READ  R EH D
# THE  DH AH
# ZOO  Z UW

cmudict_processed: cmudict_20_discard_stress
	cp cmudict_20_discard_stress cmudict_processed

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

kilgarriff_05_discard_fields: kilgarriff
	cat kilgarriff | awk '{print $$1, $$2}' > kilgarriff_05_discard_fields

# 36 !!WHOLE_CORPUS
# 20 the
# 10 read
# 5 read
# 1 zoo

kilgarriff_07_discard_total: kilgarriff_05_discard_fields
	cat kilgarriff_05_discard_fields | sed '1d' > kilgarriff_07_discard_total

# 20 the
# 10 read
# 5 read
# 1 zoo

kilgarriff_10_squashed: kilgarriff_07_discard_total
	cat kilgarriff_07_discard_total | ./squash_kilgarriff.py > kilgarriff_10_squashed

# 20 the
# 15 read
# 1 zoo

kilgarriff_20_sorted: kilgarriff_10_squashed
	cat kilgarriff_10_squashed | sort --numeric-sort --reverse > kilgarriff_20_sorted

kilgarriff_processed: kilgarriff_20_sorted
	cp kilgarriff_20_sorted kilgarriff_processed

# 20 the
# 15 read
# 1 zoo



############################################################

# This rule also generates the `uncorrelated` file, but I'm not
# sure how to represent this in Make syntax.
correlated_arpa: kilgarriff_processed cmudict_processed
	./make_correlated.py cmudict_processed kilgarriff_processed correlated_arpa uncorrelated

# 20 the  DH AH
# 15 read  R EH D
# 1 zoo  Z UW

correlated_ipa: correlated_arpa
	cat correlated_arpa | ./to_ipa.py > correlated_ipa


############################################################

q1_frequencies: correlated_ipa
	cat correlated_ipa | ./compute_frequencies.py > q1_frequencies

q2_post_w_frequencies: correlated_ipa
	cat correlated_ipa | ./compute_post_w_frequencies.py > q2_post_w_frequencies
