from discount import *
d_1 = "dealer 1"
c_1 = "CLASS 1"
m_1_n = "Model 1"
dp_1 = "Model 1 desc."
s_t_1 = "Status Model 1"
p_1 = "Proposed_model 1"
s_1 = 0
k_1 = 0
f_1 = 0
t_1 = "2021-05-17"
m_1 = Model(c_1, m_1_n, dp_1, s_t_1, p_1)
d1 = Discount(d_1, m_1, s_1, k_1, f_1, t_1)
d2 = Discount(d_1, m_1, s_1, k_1, f_1, t_1)

print(d1)
print(d2)
print(d1 == d2)