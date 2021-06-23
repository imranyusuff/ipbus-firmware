IP_PORT?="50001"
sim_udp_vhpidirect.so: sim_udp_vhpidirect.c
	gcc -g -shared -D IP_PORT=${IP_PORT} -o $@ -c $<

clean:
	rm sim_udp_vhpidirect.so
