function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

y_vec = zeros(num_labels, m); % k x m i.e 10x5000
for i = 1:m
	y_vec(y(i), i) = 1;
end

a1 = [ones(1,m); X']; % n+1 x m i.e 401x5000
a2 = [ones(1,m); sigmoid(Theta1*a1)]; % s2+1 x m i.e. 26x5000
hx = sigmoid(Theta2*a2); % s3 x m i.e. 10x5000

J = -sum(sum(y_vec .* log(hx) + (1-y_vec) .* log(1-hx)))/m;

t1 = Theta1(:,2:end);
t2 = Theta2(:,2:end);
reg_term = (sum(sum(t1.^2)) + sum(sum(t2.^2))) * lambda/(2*m);
J += reg_term;

delta3 = hx - y_vec; %10x5000
delta2 = (Theta2' * delta3) .* a2 .* (1 - a2); % 26x5000
delta2 = delta2(2:end,:); %25x5000

Theta1_grad = (delta2 * a1')./m + lambda/m * [zeros(hidden_layer_size,1) Theta1(:, 2:end)]; % 25x5000 * 5000*401 = 25x401 same as Theta1
Theta2_grad = (delta3 * a2')./m + lambda/m * [zeros(num_labels,1) Theta2(:, 2:end)]; % 10x5000 * 5000x26 = 10x26 same as Theta2

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];
end
