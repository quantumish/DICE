.PHONY: orig entice pace romer

orig:
	cd original && ampl DICE_update.run && cd -

entice:
	cd entice && ampl DICE_update.run && cd -

pace:
	cd pace && ampl DICE_update.run && cd -

romer:
	cd romer && ampl DICE_update.run && cd -
