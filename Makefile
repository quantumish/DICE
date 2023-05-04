.PHONY: orig entice pace romer

orig:
	cd original
	rm out/*.csv
	ampl DICE_update.run
	cd -

entice:
	cd entice
	rm out/*.csv
	ampl DICE_update.run
	cd -

pace:
	cd pace
	rm out/*.csv
	ampl DICE_update.run
	cd -

romer:
	cd romer
	rm out/*.csv
	ampl DICE_update.run
	cd -
