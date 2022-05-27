class OffRamp:
	"""Class modeling the off-ramps on an highway stretch in the CTM-s model"""
	def __init__(self, ID, i, beta_r):
		self.ID_offramp = ID
		self.i = i
		self.beta_r = beta_r
		self.s_r = 0
		self.k = 0

	def toString(self):
		## Utility method to print some information about the off-ramp

		print("Off-Ramp ID: "+str(self.ID_onramp))
		print("From cell "+str(self.j))
		print("Supply: "+str(self.s_r))
		print()

	def computeSr(self, next_phi):
		## Computation of the flow leaving the mainstream get on this ramp at time instant k

		self.s_r = (self.beta_r / (1 - self.beta_r)) * next_phi 	

	def updateK(self, kappa):
		## Each iteration starts with the update of the time instant

		self.k = kappa	
		