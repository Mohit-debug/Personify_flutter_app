const user = require('../model/user');
const jwt = require('jsonwebtoken');
const formidable = require('formidable');
require('dotenv').config();
const multer = require('multer');
const fs = require('fs');
const path = require('path');

const getOneProfiles = (req, res) => {
  const { email, password } = req.query;
  

  if (!email || !password) {
    return res.status(400).json({ message: "Email and password are required." });
  }

  user
    .findOne({ email, password }, { password: 0 }) 
    .then((data) => {
      if (!data) {
        return res.status(404).json({ message: "Profile not found." });
      }
      return res.json(data);
    })
    .catch((err) => {
      return res.json({ Error: err });
    });
};


const getAllProfiles = (req, res) => {
  user.find({}, { password: 0 })
    .then((data) => {
      if (data.length === 0) {
        return res.status(404).json({ message: "No profiles found." });
      }
      console.log(data)
      return res.json(data);
    })
    .catch((err) => {
      return res.status(500).json({ Error: err });
    });
};




const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads'); 
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  },
});

const upload = multer({ storage: storage });

const newProfile = (req, res) => {
  console.log("newuser")
  const { email, username, password, phonenumber, address,admin } = req.body;
  console.log(admin);

  user
    .findOne({ username: username })
    .then((data) => {
      if (!data) {
        const newUser = new user({
          email: email,
          username: username,
          password: password,
          phonenumber: phonenumber,
          address: address,
          filename:req.file.filename,
          admin:admin
        });

        // Check if an image was uploaded
        // if (req.file) {
        //   newUser.filename = req.file.filename;
        // }
        console.log(newUser.filename);

        return newUser.save();
      } else {
        throw new Error("Details already exist");
      }
    })
    .then((data) => {
      // const token = jwt.sign(data, process.env.JWT_SECRET, { expiresIn: '1h' });
      // res.setHeader('Authorization', `Bearer ${token}`);
      console.log(data);
      res.json(data);
    })
    .catch((err) => {
      // Delete the uploaded image if something goes wrong
      if (req.file) {
        fs.unlinkSync(`uploads/${req.file.filename}`);
      }

      return res.json({ Error: err.message || "Something went wrong, please try again." });
    });
};

module.exports = { newProfile };


const updateUserPassword = (req, res) => {
  const { email, newPassword } = req.body;

  // Check if email and newPassword are provided
  if (!email || !newPassword) {
    return res.status(400).json({ message: "Email and newPassword are required." });
  }

  // Find the user by email and update the password
  user.findOneAndUpdate(
    { email }, // Use only email field to find the user
    { password: newPassword }, // Update the password field
    { new: true }
  )
    .then((updatedData) => {
      if (!updatedData) {
        return res.status(404).json({ message: "User not found." });
      }
      console.log("Password updated successfully:", updatedData);
      return res.json({ message: "Password updated successfully." });
    })
    .catch((err) => {
      console.error("Error updating password:", err);
      return res.status(500).json({ message: "Failed to update password." });
    });
};

const updateUserProfile = (req, res) => {
  const { email, username, phonenumber, address } = req.body; // Remove password field

  user.findOneAndUpdate(
    { email }, // Use only email field to find the user
    { username, phonenumber, address }, // Update other fields except password
    { new: true }
  )
    .then((updatedData) => {
      if (!updatedData) {
        return res.status(404).json({ message: "Profile not found." });
      }
      console.log("Updated Data:", updatedData);
      return res.json(updatedData);
    })
    .catch((err) => {
      console.error("Error updating profile:", err);
      return res.status(500).json({ message: "Failed to update profile." });
    });
};

// const updateUserProfile = (req, res) => {
//   console.log("Received data:", req.body);

//   const form = new formidable.IncomingForm();
//   form.parse(req, async (err, fields, files) => {
//     if (err) {
//       return res.status(500).json({ message: "Failed to process form data." });
//     }

//     const { email, username, phonenumber, address } = fields;

//     try {
//       let profileImageUrl = ''; // Initialize the profile image URL

//       if (files.image) {
//         // Handle image upload here
//         // You can use the 'files.image' object to access the uploaded image
//         // Implement your image upload logic and get the 'profileImageUrl'

//         // Saving image to a server directory
//         const imagePath = `./api/user/profile/${files.image.name}`;  //uploads
//         files.image.path = imagePath;

//         profileImageUrl = `http://localhost:3000/${imagePath}`;
//       }

//       // Update the user profile with the new data and image URL
//       const updatedData = await user.findOneAndUpdate(
//         { email }, // Use only email field to find the user
//         { username, phonenumber, address, profileImageUrl }, // Update other fields and image URL
//         { new: true }
//       );

//       if (!updatedData) {
//         return res.status(404).json({ message: "Profile not found." });
//       }

//       console.log("Updated Data:", updatedData);
//       return res.json(updatedData);
//     } catch (error) {
//       console.error("Error updating profile:", error);
//       return res.status(500).json({ message: "Failed to update profile." });
//     }
//   });
// };



const deleteUserProfile = (req, res) => {
  const { email } = req.query;

  if (!email) {
    return res.status(400).json({ message: "Email is required." });
  }

  user.deleteOne({ email })
    .then((data) => {
      if (data.deletedCount === 0) {
        return res.status(404).json({ message: "Profile not found." });
      } else {
        return res.json({ message: "Profile deleted." });
      }
    })
    .catch((err) => {
      return res.status(500).json({ message: "Failed to delete profile." });
    });
};


module.exports = {
  newProfile,
  getOneProfiles,
  updateUserProfile,
  deleteUserProfile,
  getAllProfiles,
  updateUserPassword,
};
