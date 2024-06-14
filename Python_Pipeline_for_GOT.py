#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


# In[2]:


# Extract the data
df = pd.read_csv("GOT_data/battles.csv")

df
df.info()


# In[3]:


# Transform the data
# Create a new dataset with the selected columns required for the data analysis
battles = df[['name', 'year', 'attacker_king', 'defender_king', 'attacker_outcome', 'attacker_size', 'defender_size']]
battles


# In[4]:


# Checking null values
battles.isnull().sum()


# In[5]:


# Replace all null values
battles = battles.copy()
battles.fillna({'attacker_king': 'No King'}, inplace=True)
battles.fillna({'defender_king':'No King'},inplace=True)
battles.fillna({'attacker_outcome':'loss'},inplace=True)

battles.isnull().sum()


# In[6]:


# Replace the null values to the average (attacker_size)
attacker_size_sum=battles.attacker_size.sum()
average=attacker_size_sum/38
average


# In[7]:


battles.fillna({'attacker_size':6280},inplace=True)


# In[8]:


# Replace the null values to the average (defender_size)
defender_size_sum=battles.defender_size.sum()
average=defender_size_sum/38
average


# In[9]:


battles.fillna({'defender_size':3214},inplace=True)


# In[10]:


# Change the datatype for analyzing
battles['attacker_size'] = battles['attacker_size'].apply(int)
battles['defender_size'] = battles['defender_size'].apply(int)
battles.dtypes


# In[11]:


# Load the data
battles.to_csv("GOT_data/battles_cleaned.csv")


# In[13]:


battles = pd.read_csv("GOT_data/battles_cleaned.csv")
battles

