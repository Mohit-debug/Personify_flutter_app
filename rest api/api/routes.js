const { Router } = require("express");
const user = require('./model/user');
const requestValidator = require('./middleware/requestValidator');
const userController = require('./controller/userController');



const router = Router();

//...........
const path = require('path');
const multer = require('multer');

const storage = multer.diskStorage({
  destination: './upload',
  filename: (req, file, cb) => {
    cb(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname));
  }
});
const upload = multer({ storage });

router.put('/user/profile/upload/:email', upload.single('image'), async(req, res) => {
  const email = req.params.email;
  console.log(email);
  console.log('Received image upload request');
  console.log(req.file);
  if (!req.file) {
    return res.status(400).send('No image file');
  }
  
  const foundUser = await user.findOne({ email });
  console.log(foundUser);
   
  if (!foundUser) {
    return res.status(404).json({ error: 'User not found' });
  }

  foundUser.filename = req.file.filename;
  await foundUser.save();

  res.status(200).send('Image uploaded successfully');
});

router.get('/user/profile/image/:email', async(req, res) => {
  const email = req.params.email;
  console.log(email);

  try{
  
  const photo = await user.findOne({email});
  
  const imagePath = path.join(__dirname,'..', 'upload', photo.filename);
 
  res.sendFile(imagePath);
  if (!photo) {
    return res.status(404).json({ error: 'Photo not found' });
  }

  
}catch (error) {
  console.error('Error fetching image by ID:', error);
  res.status(500).json({ error: 'Failed to fetch image' });
}
});

// router.get('/user/profile/avatar/:email', async (req, res) => {
//   const email = req.params.email;

//   const photo = await user.findOne({email});
//   const imagePath = path.join(__dirname, 'upload', `${photo.filename}.jpg`); // Assuming images are stored as 'email.jpg'
  
//   // Check if the image file exists
//   if (fs.existsSync(imagePath)) {
//     res.sendFile(imagePath);
//   } else {
//     res.status(404).json({ error: 'Image not found' });
//   }
// });


//...............

router.post(
  "/user/login",
  // requestValidator.validateLoginDetail(),
  // requestValidator.validate,
  upload.single('image'),
  userController.newProfile
);


router.get("/user/login", userController.getOneProfiles);

router.get("/user/login/all", userController.getAllProfiles);

router.put("/user/profile/update", userController.updateUserProfile);

router.put("/user/forgotPassword", userController.updateUserPassword);

router.delete("/user/profile/delete", userController.deleteUserProfile);

module.exports = router;
