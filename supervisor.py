import cell as c
import station as st

class Stretch:
	"""Controller class for the model, represents the system at large"""

	def __init__(self, timeLength, lastPhi, first_DBig):
		self.cells = []
		self.stations = []
		self.n_cells = 0
		self.n_stations = 0
		self.timeLength = timeLength
		self.TTT = 0
		self.delta_big = 0
		self.pi = 0
		self.lastPhi = lastPhi
		self.first_DBig = first_DBig

	def toString(self):
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
		pass

	def computePi(self):
		pass
		
	def createCell(self, length, v, w, q, q_max, s, r, rho_max, beta, p):
		cell = c.Cell(self.n_cells, length, v, w, q, q_max, s, r, rho_max, beta, p) 
		self.cells.append(cell)
		self.n_cells = self.n_cells + 1

	def createStation(self, r_s_max, i, j, delta, beta_s, p):
		station = st.Station(self.n_stations, r_s_max, i, j, delta, beta_s, p) 
		self.stations.append(station)
		self.n_stations = self.n_stations + 1

	def setT(self, newT):
		self.timeLength=newT

	def update(self):
		#Station update
		cong = 0
		for s in self.stations:
			for c in self.cells:
					if(s.i==c.ID_cell):
						s.computeSs(c.phi_minus)
					if(s.j==c.ID_cell):
						cong=c.congestionState

			s.computeRs(cong)
			s.computeL(self.timeLength)
			s.computeE(self.timeLength)
			s.computeDsBig(self.timeLength)


		#Cell update
		beta=0
		total_beta=0
		total_Rs = 0 
		total_Ds=0
		next_phi = 0
		prev_DBig = 0

		for i in range (len(self.cells)):
			
			# loop to fetch information from inflowing and outflowing stations for the considered cell
			
			for s in self.stations:
			# outflow
				if(s.j==i):
					total_Rs = total_Rs + s.Rs
					total_Ds=total_Ds+s.d_s_big
			# inflow
				if(s.i==i):
					ss=s.Ss
					beta=s.beta_s
					total_beta = total_beta + s.beta_s
				else:
					ss=0

			# special treatment for last cell
			if((i+1) < (len(self.cells))):
				next_phi = self.cells[i+1].phi
			else:
				next_phi = self.lastPhi 		# Static assignment from data for last cell

			# special treatment for first cell
			if(i != 0):
				prev_DBig = self.cells[i-1].DBig
			else:
				prev_DBig = self.first_DBig		# Static assignment from data for first cell

			c.updateCongestionState(prev_DBig, total_Ds)
			c.computePhi(prev_DBig, total_Ds)
			c.computeRho(self.timeLength, ss, next_phi, total_Rs)
			c.computeDBig(total_beta)
			c.computeSBig()
					
			
			
			
			

		


