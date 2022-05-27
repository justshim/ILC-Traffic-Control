import cell as c
import station as st
import on_ramp as onr
import off_ramp as offr

class Stretch:
	"""Controller class for the model, represents the system at large"""

	def __init__(self, timeLength, lastPhi, phi_zero):
		self.cells = []
		self.stations = []
		self.on_ramps = []
		self.off_ramps = []
		self.n_cells = 0
		self.n_stations = 0
		self.n_on_ramps = 0
		self.n_off_ramps = 0
		self.timeLength = timeLength ### T[h]
		self.TTT = 0
		self.delta_big = 0
		self.pi = 0
		self.lastPhi = lastPhi
		self.phi_zero = phi_zero

	def toString(self):
		## Utility method to print some information about the highway stretch

		for c in self.cells:
			c.toString()
		for s in self.stations:
			s.toString()
		print("N_cells: "+str(self.n_cells))
		print("N_stations: "+str(self.n_stations))
		print("timeLength: "+str(self.timeLength))
		print("TTT: "+str(self.TTT))
		print("delta_big: "+str(self.delta_big))
		print("pi: "+str(self.pi))
		print()


	def computeDelta(self):
		## Computation of the additional TTT (total travel time) due to congestions on this stretch

		pass

	def computePi(self):
		## Computation of percentage of peak congestion reduction on this stretch

		pass
		
	def createCell(self, length, v, w, q_max, rho_max, p):
		## Method to create an instance of the object Cell, and add it to this stretch

		cell = c.Cell(self.n_cells, length, v, w, q_max, rho_max, p) 
		self.cells.append(cell)
		self.n_cells = self.n_cells + 1

	def createStation(self, r_s_max, i, j, delta, beta_s, p):
		## Method to create an instance of the object Station, and add it to this stretch

		station = st.Station(self.n_stations, r_s_max, i, j, delta, beta_s, p) 
		self.stations.append(station)
		self.n_stations = self.n_stations + 1

	def createOnRamp(self, d_r, r_r_max, j, p_r):
		## Method to create an instance of the object Station, and add it to this stretch

		on_ramp = onr.OnRamp(self.n_on_ramps, d_r, r_r_max, j, p_r) 
		self.on_ramps.append(on_ramp)
		self.n_on_ramps = self.n_on_ramps + 1

	def createOffRamp(self, i, beta_r):
		## Method to create an instance of the object Station, and add it to this stretch

		off_ramp = offr.OffRamp(self.n_off_ramps, i, beta_r) 
		self.off_ramps.append(off_ramp)
		self.n_off_ramps = self.n_off_ramps + 1

	def update(self, k):
		## Main method of the calss: at each time instant k updates all the parameters of the cells and service stations on this stretch

		#print("Time instant: " + str(k))
		prev_DBig = 0		# initialization of support variables used later
		totalDs = 0
		Ss_tot = 0

		## First of all update time instant for all cells with current k
		for i in range (len(self.cells)):
			self.cells[i].updateK(k)

		## Same for stations, plus computation of some preliminary values
		for s in range (len(self.stations)):
			self.stations[s].updateK(k)
			self.stations[s].computeDsBig(self.timeLength)
			#self.stations[s].computeRs()

		## Same for on-ramps, plus computation of some preliminary values
		for r_on in range (len(self.on_ramps)):
			self.on_ramps[r_on].updateK(k)
			self.on_ramps[r_on].computeDrBig(self.timeLength)
			#self.stations[r_on].computeRs()
		
		## First batch of cell value updates, with special case for cell 0
		for i in range (len(self.cells)):
			#print("Cell: " + str(i))
			totalBeta = 0		# initialization of support variables
			totalDs = 0
			prev_DBig = 0

			## For each cell, check if any station stems from it, and sum all betas (needed for the computation of D_i)
			for s in range (len(self.stations)):
				if self.stations[s].i == i:
					totalBeta += self.stations[s].beta_s

			## For each cell, check if any station stems from it, and sum all betas (needed for the computation of D_i)
			for r_off in range (len(self.off_ramps)):
				if self.off_ramps[r_off].i == i:
					totalBeta += self.off_ramps[r_off].beta_r

			## For each cell, check if any station merges in it, and sum all Ds's (needed for the computation of phi_i)
			for s in range (len(self.stations)):
				if self.stations[s].j == i:
					totalDs += self.stations[s].d_s_big

			## For each cell, check if any on-ramp merges in it, and sum all Dr's (needed for the computation of phi_i)
			for r_on in range (len(self.on_ramps)):
				if self.on_ramps[r_on].j == i:
					totalDs += self.on_ramps[s].d_r_big

			self.cells[i].computeDBig(totalBeta)
			
			# First cell does not have a "previous" cell, hence phi_(i-1) is given as input
			if(i != 0):
				prev_DBig = self.cells[i-1].DBig
				#print("prev_DBig: " + str(self.cells[i-1].DBig))
			
			else:
				prev_DBig = self.phi_zero[k]		
				#print("prev_DBig: " + str(prev_DBig))
			
			self.cells[i].computePhi(prev_DBig, totalDs)
			#print("Phi: " + str(self.cells[i].phi))

		## Second batch of cell value updates, with special case for last cell
		for i in range (len(self.cells)):
			next_phi = 0		# initialization of support variables
			totalRs = 0
			Ss_tot = 0
			#print("Cell: " + str(i))
			
			# Last cell does not have a "next" cell, hence phi_(i+1) is given as input
			if((i+1) < (len(self.cells))):
				next_phi = self.cells[i+1].phi
			
			else:
				next_phi = self.lastPhi
			
			## For each cell, check if any stations merge into it, and compute their r_s; 
			## then check if any stations stem from it, and compute their s_s. These are then summed up for use, respectively, in the computation of Phi- and Phi+
			for s in range (len(self.stations)):
				
				if self.stations[s].j == i:
					#print("i: "+str(i)+"	self.stations[s].j: "+str(self.stations[s].j))
					if self.cells[i].congestionState == 0 or self.cells[i].congestionState == 1:
	 					self.stations[s].computeRs(0, self.cells[i].congestionState)
					
					elif self.cells[i].congestionState == 2:
	 					self.iterativeProcedure(i, self.cells[i].congestionState, k)
					
					elif self.cells[i].congestionState == 3:
	 					self.iterativeProcedure(i, self.cells[i].congestionState, k)
					
					totalRs += self.stations[s].Rs
				
					#print("Rs: "+str(self.stations[s].Rs[k]))
				
				if self.stations[s].i == i:
					self.stations[s].computeSs(next_phi)
					Ss_tot += self.stations[s].Ss[k]

			for r_off in range (len(self.off_ramps)):

				if self.off_ramps[r_off].i == i:
					self.off_ramps[r_off].computeSr(next_phi)
					Ss_tot += self.off_ramps[r_off].s_r

			for r_on in range (len(self.on_ramps)):

				if self.on_ramps[r_on].j == i:
					
					if self.cells[i].congestionState == 0 or self.cells[i].congestionState == 1:
	 					self.on_ramps[r_on].computeRr(0, self.cells[i].congestionState)
					
					elif self.cells[i].congestionState == 2:
	 					rr = self.cells[i].SBig - self.cells[i-1].DBig
	 					self.on_ramps[r_on].computeRr(rr, self.cells[i].congestionState)
					
					elif self.cells[i].congestionState == 3:
	 					rr = self.cells[i].SBig * self.on_ramps[r_on].p_r
	 					self.on_ramps[r_on].computeRr(rr, self.cells[i].congestionState)
					
					totalRs += self.on_ramps[r_on].r_r

			self.cells[i].computeSBig()
			self.cells[i].computePhiMinus(Ss_tot, next_phi)
			#print("Total RS: "+str(totalRs))
			self.cells[i].computePhiPlus(totalRs)
			self.cells[i].computeRho(self.timeLength)

		## As a final step, all stations have their l and e updated
		for s in range (len(self.stations)):
			self.stations[s].computeE(self.timeLength)
			self.stations[s].computeL(self.timeLength)

		## And all ramps have their l updated
		for r_on in range (len(self.on_ramps)):
			self.on_ramps[r_on].computeL(self.timeLength)

	def iterativeProcedure(self, i, t, k):
		## Method called during the update procedure and used to assign r_s to all stations merging into the same cell in case of congestions of type 2 and 3

		demands = []		# initialization of support variables
		prev_D = self.cells[i-1].DBig
		supply = self.cells[i].SBig
		good = [0]			# list to contain "good" demands, i.e. the ones that do not saturate the flow
		sum_D_good = 0
		sum_p = 0

		for s in self.stations:
			if s.j == i:
			 	demands.append(s)

		if t == 2:
			supply_res = supply - prev_D

		elif t == 3:
			supply_res = (1 - self.cells[i].p_ms) * supply

		bad = demands		# list to contain "bad" demands, i.e. the ones that do saturate the flow
			
		# Recursively compute "bad" (E_cal_overline in the paper) and "good" (E_cal_underline in the paper)
		while len(good) != 0:
			good.clear()
			if t == 2:
				for d in demands:
					if d.d_s_big <= (supply_res - sum_D_good)/len(bad):
						bad.remove(d)
						good.append(d)
						
						#update RS for "good"
						for station in self.stations: 
							if d.ID_station == int(station.ID_station):
								station.computeRs(d.d_s_big, t)

						sum_D_good = sum_D_good + d.d_s_big

						supply_res = supply_res - d.d_s_big
			elif t == 3:
				for d in demands:
					if d.d_s_big <= (((1 - self.cells[i].p_ms) * supply_res) - sum_D_good)/len(bad):
						bad.remove(d)
						good.append(d)
						
						#update RS for "good"
						for station in self.stations: 
							if d.ID_station == int(station.ID_station):
								station.computeRs(d.d_s_big, t)
						
						sum_D_good = sum_D_good + d.d_s_big

						supply_res = (1 - self.cells[i].p_ms) * supply_res - d.d_s_big  ## VERIFICARE FORMULA

		# Compute sum of priorities for all involved stations
		for b in bad:
			sum_p = sum_p + b.p

		# Update RS for "bad"
		for b in bad:	
			for station in self.stations: 
				if b.ID_station == int(station.ID_station):
					station.computeRs((b.p/sum_p) * supply_res, t)
					#print("Stazione n: "+str(station.ID_station) + " RS:" + str(station.Rs[k]))