const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String },
  phone: { type: String, required: true },
  role: {
    type: String,
    enum: ['Customer', 'Home Cook', 'Delivery Partner'],
    required: true
  },
  status: {
    type: String,
    enum: ['active', 'inactive'],
    default: 'active'
  },
  createdAt: { type: Date, default: Date.now },
});

const User = mongoose.model('User', userSchema);

// Register / Login
router.post('/login-or-register', async (req, res) => {
  try {
    const { name, email, phone, role } = req.body;

    if (!name || !phone || !role) {
      return res.status(400).json({
        success: false,
        message: 'Name, phone and role are required',
      });
    }

    if (email) {
      const emailExists = await User.findOne({
        email: email.toLowerCase(),
        phone: { $ne: phone }
      });
      if (emailExists) {
        return res.status(400).json({
          success: false,
          message: 'This email is already registered with a different account',
        });
      }
    }

    let user = await User.findOne({ phone, role });

    if (user) {
      user.name = name;
      if (email) user.email = email.toLowerCase();
      await user.save();

      return res.status(200).json({
        success: true,
        isNewUser: false,
        message: 'Welcome back!',
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          phone: user.phone,
          role: user.role,
          status: user.status,
        }
      });
    }

    user = await User.create({
      name,
      email: email ? email.toLowerCase() : '',
      phone,
      role,
    });

    return res.status(201).json({
      success: true,
      isNewUser: true,
      message: 'Account created successfully!',
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        status: user.status,
      }
    });

  } catch (error) {
    console.error(error);
    return res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message,
    });
  }
});

// Get all users
router.get('/users', async (req, res) => {
  try {
    const users = await User.find().sort({ createdAt: -1 });
    return res.status(200).json({
      success: true,
      users,
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

// Update user status
router.put('/users/:id', async (req, res) => {
  try {
    const { status } = req.body;
    const user = await User.findByIdAndUpdate(
      req.params.id,
      { status },
      { new: true }
    );
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }
    return res.status(200).json({ success: true, user });
  } catch (error) {
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

// Delete user
router.delete('/users/:id', async (req, res) => {
  try {
    const user = await User.findByIdAndDelete(req.params.id);
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found' });
    }
    return res.status(200).json({ success: true, message: 'User deleted' });
  } catch (error) {
    return res.status(500).json({ success: false, message: 'Server error' });
  }
});

module.exports = router;