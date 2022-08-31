import math
import pandas as pd
import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt
from tensorflow.keras import Model
from tensorflow.keras import Sequential
from tensorflow.keras.optimizers import Adam
from sklearn.preprocessing import StandardScaler
from tensorflow.keras.layers import Dense, Dropout
from sklearn.model_selection import train_test_split
from tensorflow.keras.losses import MeanSquaredLogarithmicError

TRAIN_DATA_PATH = 'C:/Users/adria/Documents/Uni/LM II anno/Tesi/python/' \
                  'CTM-s/model/optimization/matlab/data models/4 vars/ide_set.csv'
TEST_DATA_PATH = 'C:/Users/adria/Documents/Uni/LM II anno/Tesi/python/' \
                 'CTM-s/model/optimization/matlab/data models//4 vars/val_set.csv'
TRAIN_DATA_PATH = './matlab/data models/4 vars/ide_set.csv'
TEST_DATA_PATH = './matlab/data models//4 vars/val_set.csv'

TARGET_NAME = 'integral'

# x_train = features, y_train = target
train_data = pd.read_csv(TRAIN_DATA_PATH)
train_data = train_data.drop('priority', axis=1)
train_data = train_data.drop('max_delta', axis=1)
train_data = train_data.drop('pi', axis=1)

test_data = pd.read_csv(TEST_DATA_PATH)
test_data = test_data.drop('priority', axis=1)
test_data = test_data.drop('pi', axis=1)
test_data = test_data.drop('max_delta', axis=1)

x_train, y_train = train_data.drop(TARGET_NAME, axis=1), train_data[TARGET_NAME]
x_test, y_test = test_data.drop(TARGET_NAME, axis=1), test_data[TARGET_NAME]


def scale_datasets(x_train, x_test):
    # Standard Scale test and train data
    # Z - Score normalization
    standard_scaler = StandardScaler()
    x_train_scaled = pd.DataFrame(
        standard_scaler.fit_transform(x_train),
        columns=x_train.columns
    )
    print("mean: " + str(standard_scaler.mean_))
    print("var: " + str(standard_scaler.var_))
    print(x_train_scaled)
    data_orig = standard_scaler.inverse_transform(x_train_scaled)
    print(data_orig)


    x_test_scaled = pd.DataFrame(
        standard_scaler.fit_transform(x_test),
        columns=x_test.columns
    )
    #print("mean: " + str(standard_scaler.mean_))
    #print("var: " + str(standard_scaler.var_))


    return x_train_scaled, x_test_scaled


x_train_scaled, x_test_scaled = scale_datasets(x_train, x_test)

hidden_units1 = 160
hidden_units2 = 480
hidden_units3 = 256
learning_rate = 0.01


# Creating model using the Sequential in tensorflow
# Dense = fully connected layer, with num of outputs; Dropout helps avoid overfitting
def build_model_using_sequential():
    mdl = Sequential([
        Dense(hidden_units1, kernel_initializer='normal', activation='relu'),
        Dropout(0.2),
        Dense(hidden_units2, kernel_initializer='normal', activation='relu'),
        Dropout(0.2),
        Dense(hidden_units2, kernel_initializer='normal', activation='relu'),
        Dropout(0.2),
        Dense(hidden_units3, kernel_initializer='normal', activation='relu'),
        Dense(1, kernel_initializer='normal', activation='linear')
    ])
    return mdl


# build the model
model = build_model_using_sequential()

# loss function
msle = MeanSquaredLogarithmicError()
# model settings for learning
# Adam is a stochastic gradient descent method based on adaptive estimation of first-order and second-order moments
model.compile(
    loss=msle,
    optimizer=Adam(learning_rate=learning_rate),
    metrics=[msle]
)
# train the model
history = model.fit(
    x_train_scaled.values,
    y_train.values,
    epochs=10,
    batch_size=64,
    validation_split=0.2
)


def plot_history(history, key):
    plt.plot(history.history[key])
    plt.plot(history.history['val_' + key])
    plt.xlabel("Epochs")
    plt.ylabel(key)
    plt.legend([key, 'val_' + key])
    plt.show()


# Plot the history
plot_history(history, 'mean_squared_logarithmic_error')

# x_test['prediction'] = model.predict(x_test_scaled)





standard_scaler = StandardScaler(with_mean=True, with_std=True, copy=True)

data=[[1, 3, 500, 0.5],[36, 34, 5000, 0.5]]
#Fittedscaler = standard_scaler.fit(data)
data_scaled=standard_scaler.fit_transform(data),
print(data_scaled)



ciao = tf.constant([data_scaled], dtype=tf.float32)
aaa = model(ciao)
print(aaa)





# st_in = np.linspace(1, 12, 12)
# st_out = np.linspace(2, 13, 12)
# beta = np.linspace(0, 0.2, 10)
# delta = np.linspace(0, 720, 24)
# sol = []
# for i in st_in:
#     for j in st_out:
#         if j-i > 1:
#             for b in beta:
#                 for d in delta:
#                     sol.append(model.call(tf.constant([i, j, b, d])))
#
# print(min(sol))
