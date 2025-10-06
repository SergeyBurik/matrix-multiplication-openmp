import pandas as pd
import matplotlib.pyplot as plt

# Strong scaling
df_strong = pd.read_csv("results.csv")
df_strong.columns = df_strong.columns.str.strip() 
# усредняем по run
strong_avg = df_strong.groupby("P")["elapsed"].mean().reset_index()
strong_avg["speedup"] = strong_avg["elapsed"].iloc[0] / strong_avg["elapsed"]

plt.figure(figsize=(10, 5))
plt.subplot(1, 2, 1)
plt.plot(strong_avg["P"], strong_avg["elapsed"], marker='o')
plt.title("Strong Scaling: Time vs Threads")
plt.xlabel("Number of threads (P)")
plt.ylabel("Time (s)")
plt.grid(True)

plt.subplot(1, 2, 2)
plt.plot(strong_avg["P"], strong_avg["speedup"], marker='o', color='orange')
plt.title("Strong Scaling: Speedup vs Threads")
plt.xlabel("Number of threads (P)")
plt.ylabel("Speedup")
plt.grid(True)

plt.tight_layout()
plt.savefig("strong_scaling.png")
plt.show()


# Weak scaling
df_weak = pd.read_csv("results_weak.csv")
df_weak.columns = df_weak.columns.str.strip() 

# усредняем по run
weak_avg = df_weak.groupby("P")["elapsed"].mean().reset_index()
weak_avg["ideal_time"] = weak_avg["elapsed"].iloc[0]  # идеальное время при P=1
weak_avg["efficiency"] = weak_avg["ideal_time"] / weak_avg["elapsed"]

plt.figure(figsize=(10, 5))
plt.subplot(1, 2, 1)
plt.plot(weak_avg["P"], weak_avg["elapsed"], marker='o')
plt.title("Weak Scaling: Time vs Threads")
plt.xlabel("Number of threads (P)")
plt.ylabel("Time (s)")
plt.grid(True)

plt.subplot(1, 2, 2)
plt.plot(weak_avg["P"], weak_avg["efficiency"], marker='o', color='green')
plt.title("Weak Scaling: Efficiency vs Threads")
plt.xlabel("Number of threads (P)")
plt.ylabel("Efficiency")
plt.grid(True)

plt.tight_layout()
plt.savefig("weak_scaling.png")
plt.show()

