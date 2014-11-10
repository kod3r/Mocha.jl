export DataLayer, LossLayer, StatLayer, CompLayer

export HDF5DataLayer, MemoryDataLayer
export InnerProductLayer, ConvolutionLayer, PoolingLayer, SoftmaxLayer
export SquareLossLayer, SoftmaxLossLayer, MultinomialLogisticLossLayer
export AccuracyLayer

export setup, forward, backward

############################################################
# Implementing a Layer
#
# A Layer object is a configuration of how a layer is going
# to behave. The following fields are needed by the neural
# network engine:
#
# - tops: An array of strings, as the name of output blobs.
#       Note tops is optional for LossLayer and StatLayer.
# - bottoms: An array of strings for the name of input blobs.
#       Data Layers can omit this field.
#
# To add functional operation for the layer, a layer state
# type should be defined as a sub-type of LayerState. A
# LayerState object stores all the states and intermediate
# computation results of each layer. The following fields
# are needed by the neural network engine:
#
# - blobs: An array of blobs. Corresponding to the output
#       of this layer in the forward pass.
#
# If the layer needs back propagated gradient from upper
# layer, then the following fields are required:
#
# - blobs_diff: An array of blobs. Corresponding to the
#       gradient of the objective function with respect
#       to the output of this layer in the backward pass.
#       Note this value is computed by the upper layer.
#
# Optional each layer can have an activation function
# by defining a field called neuron. The activation
# function computation (both forward and backward)
# are handled automatically by the engine.
#
# If the layer has its own parameters that need to be updated
# during optimization, the following field should be defined
#
# - parameters: vector of Parameters
#
# Note the layer needs to compute the gradient of the parameter
# during the backward pass, but everything else will be taken
# care of automatically by the engine, including the followings:
#
# - initialize the parameters before optimization starts
# - compute the regularization and its gradient during forward
#   and backward pass, respectively
# - update the parameter after one forward-backward pass
#
# Then the following functions need to be defined
#
# - setup(sys::System,layer::MyLayer,inputs::Vector{Blob})
#   This function construct the layer state object and do
#   necessary initialization. The inputs are initialized
#   with proper shape, but not necessarily with valid data
#   values. The constructed layer state should be returned.
#
# - forward(sys::System,state::MyLayerState,inputs::Vector{Blob})
#   This function do the forward computation: inputs are
#   forward computed output from bottom layers.
#
# - backward(sys::System,state::MyLayerState,inputs::Vector{Blob},diffs::Vector{Blob})
#   This function do the backward computation: inputs are
#   the same as in forward, diffs contains blobs to hold
#   gradient with respect to the bottom layer input. Some
#   blob in this vector might be "undefined", meaning that
#   blob do not want to get back propagated gradient. This
#   procedure also compute gradient with respect to layer
#   parameters if any.
############################################################

abstract DataLayer <: Layer # Layer that provide data
abstract LossLayer <: Layer # Layer that defines loss function for learning
abstract StatLayer <: Layer # Layer that provide statistics (e.g. Accuracy)
abstract CompLayer <: Layer # Layer that do computation

#############################################################
# Data Layers
#############################################################
include("layers/hdf5-data.jl")
include("layers/memory-data.jl")

#############################################################
# General Computation Layers
#############################################################
include("layers/inner-product.jl")
include("layers/convolution.jl")
include("layers/pooling.jl")
include("layers/softmax.jl")

#############################################################
# Loss Layers
#############################################################
include("layers/square-loss.jl")
include("layers/multinomial-logistic-loss.jl")
include("layers/softmax-loss.jl")

#############################################################
# Statistics Layers
#############################################################
include("layers/accuracy.jl")


#############################################################
# Default procedures for layers that do not need them
#############################################################
function backward(sys::System, state::LayerState, inputs::Vector{Blob}, diffs::Vector{Blob})
end
