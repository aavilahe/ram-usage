# Install widgets and prepare for release
#
# Author: Aram Avila-Herrera
# Date: July 28, 2015
#
# License: See LICENSE

WIDGET_DIR ?= ~/Library/"Application Support"/Übersicht/widgets
WIDGET = ram-usage.widget
LIBS = d3js

install: $(WIDGET)
	cp -R $(WIDGET) $(WIDGET_DIR)/
	- cp -R -n $(LIBS) $(WIDGET_DIR)/

$(WIDGET).zip: $(WIDGET)
	zip -r $@ $<

zip: $(WIDGET).zip
