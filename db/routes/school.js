const express = require('express');
const router = express.Router();
const {getSchool,getSchoolID,postSchool,updateSchool,deleteSchool,} = require('../controllers/SchoolController');
const authenticateToken = require('../middlewares/auth');

router.get('/', getSchool);
router.get('/:id', getSchoolID);
router.post('/', postSchool);
router.put('/:id', updateSchool);
router.delete('/:id', deleteSchool);

module.exports = router;
