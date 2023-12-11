
import matplotlib.pyplot as plt
import numpy as np

def calc_ray_segment_intersection(p, d, a, b):
  v1 = p - a
  v2 = b - a
  v3 = np.array([-d[1], d[0]])
  t = np.cross(v2, v1)/np.dot(v2, v3)
  u = np.dot(v1, v3)/np.dot(v2, v3)
  return p + t*d

def intersects(p, d, a, b):
  v1 = p - a
  v2 = b - a
  v3 = np.array([-d[1], d[0]])
  t = np.cross(v2, v1)/np.dot(v2, v3)
  u = np.dot(v1, v3)/np.dot(v2, v3)
  return t >= 0 and 0 <= u <= 1

p = np.array([0,0])
d = np.array([1,1])
a = np.array([np.random.uniform(0, 10), np.random.uniform(0, 10)])
b = np.array([np.random.uniform(0, 10), np.random.uniform(0, 10)])

print("p =", p)
print("d =", d)
print("a =", a)
print("b =", b)
print(intersects(p, d, a, b))

pi = calc_ray_segment_intersection(p, d, a, b)

plt.plot([a[0], b[0]], [a[1], b[1]])
p1 = p + 4*d
plt.plot([p[0], p1[0]], [p[1], p1[1]], color="red")
plt.scatter([pi[0]], [pi[1]], color="k")

plt.show()

