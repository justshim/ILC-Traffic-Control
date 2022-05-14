import cell as c
import supervisor as s

class Factory:
	"""Class for the creation of instances of cells and stations""" 
	def __init__(self):
		self.stretches=[]
		self.n_stretches=0

	def createStretch(self, TimeLength, last_phi, first_DBig):
		stretch = s.Stretch(TimeLength, last_phi, first_DBig)
		self.stretches.append(stretch)
		self.n_stretches = self.n_stretches+1

	def addCellToStretch(self, ID_stretch, length, v, w, q, q_max, s, r, rho_max, beta, p):
		self.stretches[ID_stretch].createCell(length, v, w, q, q_max, s, r, rho_max, beta, p)

	def addStationToStretch(self, ID_stretch, r_s_max, i, j, delta, beta_s, p):
		self.stretches[ID_stretch].createStation(r_s_max, i, j, delta, beta_s, p)
		