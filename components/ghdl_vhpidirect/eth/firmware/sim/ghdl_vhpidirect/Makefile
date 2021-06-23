TAP_DEV?="tap0"
mac_vhpidirect.so: mac_vhpidirect.c
	gcc -g -shared -D TAP_DEV=${TAP_DEV} -o $@ -c $<

clean:
	rm mac_vhpidirect.so
