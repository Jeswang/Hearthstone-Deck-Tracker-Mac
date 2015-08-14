/*************************************************************************
 *
 * TIGHTDB CONFIDENTIAL
 * __________________
 *
 *  [2011] - [2014] TightDB Inc
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of TightDB Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to TightDB Incorporated
 * and its suppliers and may be covered by U.S. and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from TightDB Incorporated.
 *
 **************************************************************************/
#ifndef TIGHTDB_COMMIT_LOG_HPP
#define TIGHTDB_COMMIT_LOG_HPP

#ifdef TIGHTDB_ENABLE_REPLICATION

#include <exception>

#include <tightdb/replication.hpp>
#include <tightdb/binary_data.hpp>
#include <tightdb/lang_bind_helper.hpp>

namespace tightdb {

class LogFileError : public std::runtime_error {
public:
    LogFileError(const std::string file_name) : std::runtime_error(file_name) {}
};

// Create a writelog collector and associate it with a filepath. You'll need one writelog
// collector for each shared group. Commits from writelog collectors for a specific filepath 
// may later be obtained through other writrlog collectors associated with said filepath.
// The caller assumes ownership of the writelog collector and must destroy it, but only AFTER
// destruction of the shared group using it.
Replication* makeWriteLogCollector(std::string filepath,
                                   bool server_synchronization_mode = false,
                                   const char *encryption_key = 0);

} // namespace tightdb

#endif // TIGHTDB_ENABLE_REPLICATION

#endif // TIGHTDB_COMMIT_LOG_HPP
